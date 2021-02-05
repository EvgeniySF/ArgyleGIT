public class UTMDataWrapper {
        public String utm_source;
        public String utm_medium; 
        public String utm_campaign;
        public String utm_content;
        
        public UTMDataWrapper(Map<String, String> pageParameters) { 
            this.utm_source = pageParameters.get('utm_source') != null ? pageParameters.get('utm_source') : '';
            this.utm_medium = pageParameters.get('utm_medium') != null ? pageParameters.get('utm_medium') : '';
            this.utm_campaign = pageParameters.get('utm_campaign') != null ? pageParameters.get('utm_campaign') : '';
            this.utm_content = pageParameters.get('utm_content') != null ? pageParameters.get('utm_content') : '';
        }
    }