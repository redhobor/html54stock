<%@ Page Language="C#" %>
<script runat="server">
    protected override void OnPreRender(EventArgs e){
        Response.ContentType = "text/xml";
        Response.ContentEncoding = Encoding.UTF8;

        string url = Request.QueryString["url"];
        
        string randomPart = "random=";
        int randomIndex = url.LastIndexOf(randomPart);
        string noRandomUrl;
        if(randomIndex>0){
            noRandomUrl = url.Substring(0,randomIndex-1);
        }else{
            noRandomUrl = url;
        }
        
        string cacheKey = string.Format("proxy-{0}",noRandomUrl);
        string html = (string)Cache.Get(cacheKey);
        if(html==null){
            using(System.Net.WebClient wc = new System.Net.WebClient()){
                html = wc.DownloadString(url);
            }

            Cache.Insert(cacheKey,html,null,Cache.NoAbsoluteExpiration,TimeSpan.FromMinutes(1),CacheItemPriority.AboveNormal,null);
        }

        Response.Write(html);
    }
</script>