/*
Salida: 131615
Local:  31
*/

--
--  RESET SALIDA
--
declare
    vl_local number := 31;--914;
    vl_salida number := 131615;
begin
    jsyb_fnd_funciones.JSYB_FND_SET_EMPRESA( 1 );
    
    update  SALIDAS_DET_TL
    set     estado = 'GD'
    where   numero = vl_salida
    and     lo_codigo = vl_local;
    
    update  BANDEJAS
    set     estado = 'TR',
            ind_revision_rcm = null
    where   numero = vl_salida
    and     lo_codigo = vl_local;
    
    delete  JSYB_RCM_DETALLE_REVISION
    where   numero_salida = vl_salida
    and     lo_codigo = vl_local;
    
    delete  JSYB_RCM_REVISIONES_CONTENIDO
    where   numero_salida = vl_salida
    and     lo_codigo = vl_local;
    
    delete  JSYB_RCM_BANDEJAS
    where   numero_salida = vl_salida
    and     lo_codigo = vl_local;
    
    delete  JSYB_RCM_SALIDAS_PROC
    where   numero_salida = vl_salida
    and     lo_codigo = vl_local;
    
    delete  JSYB_BG_MOVS_BANDEJA
    where   codigo_bandeja in (
                select  b.codigo_bandeja
                from    BANDEJAS b
                where   numero = vl_salida
                and     lo_codigo = vl_local
            );
    
    update  DETALLE_X_BANDEJAS
        set estado_traspaso_pp = NULL,
            estado_traspaso_pt = NULL,
            estado_traspaso_td = NULL
    where   codigo_bandeja in (
                select  b.codigo_bandeja
                from    BANDEJAS b
                where   numero = vl_salida
                and     lo_codigo = vl_local
            );
            
    delete  JSYB_BG_OTR_BOD_VALE_RECEP
    where   numero_salida = vl_salida
    and     lo_codigo = vl_local;
    
    delete  JSYB_BG_BULTOS_VALE_RECEP
    where   numero_vale_recep in (
                select  v.numero_vale_recep
                from    JSYB_BG_VALE_RECEPCION_SALIDA v
                where   numero_salida = vl_salida
                and     lo_codigo = vl_local
            );
    
    delete  JSYB_BG_VALE_RECEPCION_SALIDA
    where   numero_salida = vl_salida
    and     lo_codigo = vl_local;
    
    commit;
end;