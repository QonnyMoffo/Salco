--
--  Reset RB
--
declare
    vl_local number := 31;--914;
    vl_salida number := 131615;
    vl_empresa number := 1;
    vl_org_inv number := 228;
    vl_org_loc number := 5;
    vl_org_cd number := 2;
    
    vl_nro_doc number;
begin
    JSYB_FND_FUNCIONES.Jsyb_Fnd_Set_Empresa( 1 );
    
    select  numero_interno into vl_nro_doc
    from    DOCUMENTOS_ENC_TL
    where   organization_id = vl_org_loc
    and     numero_salida = vl_salida
    and     lo_codigo = vl_local;
    
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
    where   codigo_empresa = vl_empresa
    and     numero_salida = vl_salida
    and     lo_codigo = vl_local;
    
    delete  JSYB_RCM_REVISIONES_CONTENIDO
    where   codigo_empresa = vl_empresa
    and     numero_salida = vl_salida
    and     lo_codigo = vl_local;
    
    delete  JSYB_RCM_BANDEJAS
    where   codigo_empresa = vl_empresa
    and     numero_salida = vl_salida
    and     lo_codigo = vl_local;
    
    delete  JSYB_RCM_SALIDAS_PROC
    where   codigo_empresa = vl_empresa
    and     numero_salida = vl_salida
    and     lo_codigo = vl_local;
    
    delete  JSYB_BG_MOVS_BANDEJA
    where   codigo_bandeja in (
                select  b.codigo_bandeja
                from    BANDEJAS b
                where   numero = vl_salida
                and     lo_codigo = vl_local
            );
    
    update  DETALLE_X_BANDEJAS
    set     estado_traspaso_pp = NULL,
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
    
    
    delete  TRANSACCIONES_DOCUMENTO
    where   organization_id = vl_org_loc
    and     numero_interno = vl_nro_doc;
    
    delete  DOCUMENTOS_DET_TL
    where   organization_id = vl_org_loc
    and     numero_interno = vl_nro_doc;
    
    delete  DOCUMENTOS_ENC_TL
    where   organization_id = vl_org_loc
    and     numero_interno = vl_nro_doc;
    
    commit;
end;