lizMap.events.on({
    uicreated: function () {
        // 👇 chemin relatif depuis le root de Lizmap vers le fichier HTML
        const iframeUrl = '/index.php/view/media/getMedia?repository=zoneshumides&project=inventaire_zh&path=media/js/default/01_addDoc.html';

        lizMap.addDock(
            'notice',
            'Notice',
            'right-dock',
            `<iframe 
              src="${iframeUrl}" 
              style="height: calc(100vh - 140px); width: 100%; border: none;" 
              scrolling="no" 
              frameborder="0">
            </iframe>`,
            'icon-file'
        );

        // 👉 Affiche le dock au démarrage
        $('#mapmenu li.notice:not(.active) a').click();

        // 👉 Cache la légende pour plus de place
        // $('#mapmenu li.switcher.active a').click();

        // ⛶ Bouton plein écran
        if (!$('#btn-fullscreen').length) {
            const buttonHtml = '<button id="btn-fullscreen" class="btn btn-default" title="Ouvrir en plein écran">⛶</button>';
            $('#right-dock').append(buttonHtml);
            $('#btn-fullscreen').css({
                position: 'absolute',
                top: '5px',
                right: '45px',
                padding: '0px 3px 2px 4px',
                fontSize: '18px',
                width: '32px',
                height: '32px',
                backgroundColor: '#d6d6d6'
                //, display: 'none'
            }).on('click', function () {
                window.open(iframeUrl);
            });
        }
    },

    rightdockopened: function (e) {
        const isDocDock = e.id === 'doc';
        $('#bouton1').css('display', isDocDock ? 'block' : 'none');
    }
});
