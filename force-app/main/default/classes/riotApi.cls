public with sharing class riotApi {
    public String accountId{get;set;}
    public Integer profileIconId{get;set;}
    public long revisionDate{get;set;}
    public String name{get;set;}
    public String id{get;set;}
    public String puuid{get;set;}
    public long summonerLevel{get;set;}
    public String ending {get;set;}
    public String profileImg {get;set;}
    public List<String> games {get;set;}
    public List<String> champions {get;set;}
    public List<String> campeones = new List<String>();
    public boolean rendered {get;set;}
    
    public String keyAPI = 'RGAPI-8e339a82-b945-477e-b432-9e01db9c7f01';
    
    public void getSummonerData(){
        String preEndPoint = 'https://euw1.api.riotgames.com/lol/summoner/v4/summoners/by-name/';
        String endpoint = preEndPoint + ending;
        rendered = true;
        
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndPoint(endPoint);
        request.setMethod('GET');
        request.setHeader('X-Riot-Token', keyAPI);
        HTTPResponse response = http.send(request);
        
        if (response.getStatusCode() == 200) {
            Map<String, Object> results = (Map<String, Object>) JSON.deserializeUntyped(response.getBody());
            accountId = String.valueof(results.get('accountId'));
            
            name = string.valueof(results.get('name'));
            id = string.valueof(results.get('id'));
            puuid = string.valueof(results.get('puuid'));
            summonerLevel = Integer.valueof(results.get('summonerLevel'));
            revisionDate = Integer.valueof(results.get('revisionDate'));
            profileIconId = Integer.valueof(results.get('profileIconId'));
            profileImg = 'https://ddragon.leagueoflegends.com/cdn/12.10.1/img/profileicon/'+ profileIconId  +'.png';

            Games = getGameHistory(puuid);
            for (String game : Games) {
                champions = getGame(game);
            }
        }
    }

    public List<String> getGameHistory(String puuid){
        String endPoint = 'https://europe.api.riotgames.com/lol/match/v5/matches/by-puuid/'+ puuid + '/ids?start=0&count=5';

        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndPoint(endPoint);
        request.setMethod('GET');
        request.setHeader('X-Riot-Token', keyAPI);
        HTTPResponse response = http.send(request);

        List<String> games = new List<String>();

        if (response.getStatusCode() == 200) {
            String s = response.getBody();
            games = (List<String>) JSON.deserialize(s, List<String>.class);
        }
        return games;
    }

    public List<String> getGame(String gameID){
        String endPoint = 'https://europe.api.riotgames.com/lol/match/v5/matches/' + gameID;

        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndPoint(endPoint);
        request.setMethod('GET');
        request.setHeader('X-Riot-Token', keyAPI);
        HTTPResponse response = http.send(request);

        if (response.getStatusCode() == 200) {
            Map<String, Object> results = (Map<String, Object>) JSON.deserializeUntyped(response.getBody());
            Map<String, Object> info = (Map<String, Object>) results.get('info');
            List<Object> participants = (List<Object>) info.get('participants');

            List<Map<String, Object>> mapa = new List<Map<String, Object>>();
            for (Object obj : participants) {
                mapa.add((Map<String, Object>)obj);
            }

            for (Map<String, Object> napa : mapa) {
                campeones.add('http://ddragon.leagueoflegends.com/cdn/12.11.1/img/champion/' + String.valueof(napa.get('championName')) + '.png');
            }
            return campeones;
        } else{
            return null;
        }
    }
}