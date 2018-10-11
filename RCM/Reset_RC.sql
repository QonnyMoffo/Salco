exec jsyb_fnd_funciones.JSYB_FND_SET_EMPRESA( 1 );

/*
Salida: 131615
Local:  31
*/

update  salidas_det_tl s
set     estado = 'GD'
where   numero = 131615
and     lo_codigo = 31
and     exists (
            select  'x'
            from    bandejas b, jsyb_rcm_revisiones_contenido r
            where   b.numero = s.numero
            and     b.lo_codigo = s.lo_codigo
            and     b.bdg_codigo = s.bdg_codigo
            and     r.codigo_bandeja = b.codigo_bandeja
        );

update  bandejas b
set     estado = 'TR'
where   numero = 131615
and     lo_codigo = 31
and     exists (
            select  'x'
            from    jsyb_rcm_revisiones_contenido r
            where   r.codigo_bandeja = b.codigo_bandeja
        );

update  detalle_x_bandejas
    set ESTADO_TRASPASO_PP = null,
        ESTADO_TRASPASO_PT = null,
        ESTADO_TRASPASO_TD = null
where   codigo_bandeja in (
            select  b.codigo_bandeja
            from    bandejas b, jsyb_rcm_revisiones_contenido r
            where   b.numero = 131615
            and     b.lo_codigo = 31
            and     r.codigo_bandeja = b.codigo_bandeja
        );

update  jsyb_rcm_bandejas
    set estado = 'PREV'
where   numero_salida = 131615
and     lo_codigo = 31
and     estado in ( 'ERC', 'REV' );

delete  jsyb_bg_movs_bandeja s
where   codigo_bandeja in (
            select  b.codigo_bandeja
            from    bandejas b, jsyb_rcm_revisiones_contenido r
            where   b.numero = 131615
            and     b.lo_codigo = 31
            and     r.codigo_bandeja = b.codigo_bandeja
        );

update  detalle_x_bandejas
    set ESTADO_TRASPASO_PP = null,
        ESTADO_TRASPASO_PT = null,
        ESTADO_TRASPASO_TD = null
where   codigo_bandeja in (
            select  b.codigo_bandeja
            from    bandejas b, jsyb_rcm_revisiones_contenido r
            where   b.numero = 131615
            and     b.lo_codigo = 31
            and     r.codigo_bandeja = b.codigo_bandeja
        );
        
delete  jsyb_rcm_detalle_revision
where   numero_salida = 131615
and     lo_codigo = 31;

delete  jsyb_rcm_revisiones_contenido
where   numero_salida = 131615
and     lo_codigo = 31;

update  jsyb_rcm_salidas_proc
set     estado = 'RBC'
where   numero_salida = 131615
and     lo_codigo = 31;

delete  diferencias_item_recepcion
where   ba_codigo_bandeja in (
            select  b.codigo_bandeja
            from    bandejas b
            where   numero = 131615
            and     lo_codigo = 31
        );

commit;
