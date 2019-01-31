declare
    vl_dummy    number;
    vl_error    varchar2(2000);
    
    cursor c1 is
            select  rownum lugar, num_memo, codigo_empresa, inventory_item_id, org_id_inv,
                replace(replace(replace(replace(replace(replace(
                decode(substr(lista_locales,-1),',',substr(lista_locales,1,length(lista_locales)-1),lista_locales),
                ';',','),', ',','),' ,',','),'-',','),'.',','),'NULO',null) lista
        from    JSYB_BG_DET_MEMO_DEVOLUCION_TL
        where   lista_locales is not null;
    
    cursor c2 is
        select  rownum lugar, num_memo, codigo_empresa,
                replace(replace(replace(replace(replace(replace(
                decode(substr(lista_locales,-1),',',substr(lista_locales,1,length(lista_locales)-1),lista_locales),
                ';',','),', ',','),' ,',','),'-',','),'.',','),'NULO',null) lista
        from    JSYB_BG_MEMO_DEVOLUCION_TL
        where   lista_locales is not null;
    
    Procedure Valida_Lista( p_lista varchar2, p_lugar number, p_tipo varchar2, p_error out varchar2,
                            p_memo number, p_emp number, p_item number default null, p_org_inv number default null) is
        v_pos	integer;
        v_str	varchar2(2000);
        v_loc	varchar2(240);
        v_loc_n number;
    begin
        v_str := p_lista;
        loop
            if v_str is null then
                exit;
            end if;
            v_pos := instr(v_str,',',1);
            if v_pos = 1 then
                p_error := p_lugar||'. Lista de Locales Mal Formada. Use "coma" (,) Como Separador Entre Locales';
                exit;
            end if;
    
            if v_pos > 0 then
                v_loc := substr(v_str, 1, v_pos-1);
                if v_pos = length(v_str) then
                    v_str := NULL;
                else
                    v_str := substr(v_str, v_pos+1);
                end if;
            else
                v_loc := v_str;
                v_str := NULL;
            end if;
            
            begin
                v_loc_n := to_number(v_loc);
            exception when others then
                p_error := p_lugar||'. Local Debe Ser NUMERICO: '||v_loc;
                exit;
            end;			
            
            begin
                select  1   into    vl_dummy
                from    SU_SUCURSAL_TL
                where   su_suc_id = v_loc_n
                    and su_empresa_id = p_emp;
            exception when no_data_found then
                p_error := p_lugar||'. Local '||v_loc||', Empresa: '||p_emp||' NO Existe';
                exit;
            end;
            
            if p_tipo = 'ENC' then
                begin
                    Insert into JSYB_BG_LOC_MEMO_DEVOLUCION_TL
                    values (p_memo, p_emp, v_loc_n, null);
                exception when others then
                    p_error := p_lugar||'. NO Se Pudo Insertar Local-Cabecera. Local: '||v_loc||', Empresa: '||p_emp
                            ||'. Error: '||substr(sqlerrm,1,240);
                exit;
                end;
            end if;
            
            if p_tipo = 'DET' then
                begin
                    Insert into JSYB_BG_LOD_MEMO_DEVOLUCION_TL
                    values (p_memo, p_emp, p_org_inv, p_item, null, v_loc_n, null);
                exception when others then
                    p_error := p_lugar||'. NO Se Pudo Insertar Local-Detalle. Local: '||v_loc||', Empresa: '||p_emp
                            ||'. Error: '||substr(sqlerrm,1,240);
                exit;
                end;
            end if;
            
            v_str := ltrim(v_str);
            ---dbms_output.put_line(p_lugar||'. Bien. '||p_tipo||', Local: '||v_loc||', Empresa: '||p_emp);
        end loop;
    end;
BEGIN
    -- 0 con espacios entre numeros
    -- 5 con guiones
    -- 3 con puntos
    -- 3 con 'NULO'
    
    for d in c1 loop
        Valida_Lista(d.lista, d.lugar, 'DET', vl_error, d.num_memo, d.codigo_empresa, d.inventory_item_id, d.org_id_inv);
        if vl_error is not null then
            dbms_output.put_line(vl_error);
        end if;
    end loop;
    
    for c in c2 loop
        Valida_Lista(c.lista, c.lugar, 'ENC', vl_error, c.num_memo, c.codigo_empresa);
        if vl_error is not null then
            dbms_output.put_line(vl_error);
        end if;
    end loop;
    
    Commit;
    ---RollBack;
END;
/