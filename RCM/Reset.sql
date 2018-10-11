exec jsyb_fnd_funciones.JSYB_FND_SET_EMPRESA( 1 );

/*
Salida: 131615
Local:  31
*/

--
--  RESET SALIDA
--

update  salidas_det_tl
set     estado = 'GD'
where   numero = 131615
and     lo_codigo = 31;

update  bandejas
set     estado = 'TR',
        IND_REVISION_RCM = null
where   numero = 131615
and     lo_codigo = 31;

delete  jsyb_rcm_detalle_revision
where   numero_salida = 131615
and     lo_codigo = 31;

delete  jsyb_rcm_revisiones_contenido
where   numero_salida = 131615
and     lo_codigo = 31;

delete  jsyb_rcm_bandejas
where   numero_salida = 131615
and     lo_codigo = 31;

delete  jsyb_rcm_salidas_proc
where   numero_salida = 131615
and     lo_codigo = 31;

delete  jsyb_bg_movs_bandeja
where   codigo_bandeja in (
            select  b.codigo_bandeja
            from    bandejas b
            where   numero = 131615
            and     lo_codigo = 31
        );

update  detalle_x_bandejas
    set ESTADO_TRASPASO_PP = null,
        ESTADO_TRASPASO_PT = null,
        ESTADO_TRASPASO_TD = null
where   codigo_bandeja in (
            select  b.codigo_bandeja
            from    bandejas b
            where   numero = 131615
            and     lo_codigo = 31
        );
        
delete  jsyb_bg_otr_bod_vale_recep
where   numero_salida = 131615
and     lo_codigo = 31;

delete  jsyb_bg_bultos_vale_recep
where   NUMERO_VALE_RECEP in (
            select  v.NUMERO_VALE_RECEP
            from    jsyb_bg_vale_recepcion_salida v
            where   numero_salida = 131615
            and     lo_codigo = 31
        );

delete  jsyb_bg_vale_recepcion_salida
where   numero_salida = 131615
and     lo_codigo = 31;

commit;
