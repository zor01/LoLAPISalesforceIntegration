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
    public String matchId {get;set;}
    public String keyAPI = 'RGAPI-89d024a5-4c12-419c-a218-fe9ceb24b3b9';

    
    public void getSummonerData(){
        String preEndPoint = 'https://euw1.api.riotgames.com/lol/summoner/v4/summoners/by-name/';
        String endpoint = preEndPoint + ending;

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

            List<String> Games = GetGameHistory(puuid);
            for (String game : Games) {
                GetGame(Game);
            }
        }
    }

    private List<String> GetGameHistory(String puuid){
        String endPoint = 'https://europe.api.riotgames.com/lol/match/v5/matches/by-puuid/'+ puuid + '/ids?start=0&count=20';

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

    private void GetGame(String GameID){
        String endPoint = 'https://europe.api.riotgames.com/lol/match/v5/matches/' + GameID;

        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndPoint(endPoint);
        request.setMethod('GET');
        request.setHeader('X-Riot-Token', keyAPI);
        HTTPResponse response = http.send(request);

        if (response.getStatusCode() == 200) {
            Map<String, Object> results = (Map<String, Object>) JSON.deserializeUntyped(response.getBody());
            Map<String, Object> cosa = (Map<String, Object>) results.get('metadata');
            matchId = String.valueof(cosa.get('dataVersion'));

            System.debug(matchId);
        }
    }
}