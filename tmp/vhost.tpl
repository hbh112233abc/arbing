server {
    listen {{port}};
    server_name {{domain}};
    root "{{path}}";
    index index.php index.html;

    location / {
        try_files $uri $uri/ /index.php;
        if (!-e $request_filename) {
            rewrite  ^(.*)$  /index.php?s=$1  last;
        }
    }

    location ~ \.php(.*)$ {
        fastcgi_pass 127.0.0.1:9000;
        fastcgi_index index.php;
        fastcgi_split_path_info ^((?U).+\.php)(/?.+)$;
        fastcgi_param  SCRIPT_FILENAME  $document_root$fastcgi_script_name;
        fastcgi_param  PATH_INFO  $fastcgi_path_info;
        fastcgi_param  PATH_TRANSLATED  $document_root$fastcgi_path_info;
        include        fastcgi_params;
    }
}