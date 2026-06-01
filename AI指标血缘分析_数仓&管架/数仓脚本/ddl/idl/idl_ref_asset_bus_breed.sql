/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py idl ref_asset_bus_breed
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${idl_schema}.ref_asset_bus_breed
whenever sqlerror continue none;
drop table ${idl_schema}.ref_asset_bus_breed purge;

whenever sqlerror exit sql.sqlcode;
create table ${idl_schema}.ref_asset_bus_breed(
    etl_dt date -- 数据日期   
    ,asset_bus_breed_id varchar2(60) -- 资产业务品种编号   
    ,sort_id varchar2(60) -- 排序编号   
    ,asset_bus_breed_name varchar2(250) -- 资产业务品种名称   
    ,type_sort_id varchar2(60) -- 类型排序编号   
    ,sub_type varchar2(60) -- 子类型   
    ,attr1 varchar2(250) -- 属性1   
    ,attr2 varchar2(250) -- 属性2   
    ,attr3 varchar2(250) -- 属性3   
    ,attr4 varchar2(250) -- 属性4   
    ,attr5 varchar2(250) -- 属性5   
    ,attr6 varchar2(250) -- 属性6   
    ,attr7 varchar2(250) -- 属性7   
    ,attr8 varchar2(250) -- 属性8   
    ,attr9 varchar2(250) -- 属性9   
    ,attr10 varchar2(250) -- 属性10   
    ,attr11 varchar2(250) -- 属性11   
    ,asset_thd_cls_cd varchar2(250) -- 资产三分类代码   
    ,attr13 varchar2(250) -- 属性13   
    ,attr14 varchar2(250) -- 属性14   
    ,attr15 varchar2(250) -- 属性15   
    ,attr16 varchar2(250) -- 属性16   
    ,attr17 varchar2(250) -- 属性17   
    ,attr18 varchar2(250) -- 属性18   
    ,attr19 varchar2(250) -- 属性19   
    ,attr20 varchar2(250) -- 属性20   
    ,attr21 varchar2(250) -- 属性21   
    ,attr22 varchar2(250) -- 属性22   
    ,attr23 varchar2(250) -- 属性23   
    ,attr24 varchar2(250) -- 属性24   
    ,attr25 varchar2(250) -- 属性25   
    ,use_flg varchar2(10) -- 使用标志   
    ,loan_size_ctrl_flg varchar2(10) -- 贷款规模控制标志   
    ,prod_catlg_id varchar2(60) -- 产品目录编号   
    ,create_dt date -- 创建日期   
    ,update_dt date -- 更新日期   
    ,id_mark varchar2(10) -- 删除标识 
    ,job_cd varchar2(10) -- 任务编码  
)
partition by list(etl_dt)(
    partition p_19000101 values (to_date('19000101','yyyymmdd'))
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${idl_schema}.ref_asset_bus_breed to ${iel_schema};

-- comment
comment on table ${idl_schema}.ref_asset_bus_breed is '资产业务品种表';
comment on column ${idl_schema}.ref_asset_bus_breed.etl_dt is '数据日期';
comment on column ${idl_schema}.ref_asset_bus_breed.asset_bus_breed_id is '资产业务品种编号';
comment on column ${idl_schema}.ref_asset_bus_breed.sort_id is '排序编号';
comment on column ${idl_schema}.ref_asset_bus_breed.asset_bus_breed_name is '资产业务品种名称';
comment on column ${idl_schema}.ref_asset_bus_breed.type_sort_id is '类型排序编号';
comment on column ${idl_schema}.ref_asset_bus_breed.sub_type is '子类型';
comment on column ${idl_schema}.ref_asset_bus_breed.attr1 is '属性1';
comment on column ${idl_schema}.ref_asset_bus_breed.attr2 is '属性2';
comment on column ${idl_schema}.ref_asset_bus_breed.attr3 is '属性3';
comment on column ${idl_schema}.ref_asset_bus_breed.attr4 is '属性4';
comment on column ${idl_schema}.ref_asset_bus_breed.attr5 is '属性5';
comment on column ${idl_schema}.ref_asset_bus_breed.attr6 is '属性6';
comment on column ${idl_schema}.ref_asset_bus_breed.attr7 is '属性7';
comment on column ${idl_schema}.ref_asset_bus_breed.attr8 is '属性8';
comment on column ${idl_schema}.ref_asset_bus_breed.attr9 is '属性9';
comment on column ${idl_schema}.ref_asset_bus_breed.attr10 is '属性10';
comment on column ${idl_schema}.ref_asset_bus_breed.attr11 is '属性11';
comment on column ${idl_schema}.ref_asset_bus_breed.asset_thd_cls_cd is '资产三分类代码';
comment on column ${idl_schema}.ref_asset_bus_breed.attr13 is '属性13';
comment on column ${idl_schema}.ref_asset_bus_breed.attr14 is '属性14';
comment on column ${idl_schema}.ref_asset_bus_breed.attr15 is '属性15';
comment on column ${idl_schema}.ref_asset_bus_breed.attr16 is '属性16';
comment on column ${idl_schema}.ref_asset_bus_breed.attr17 is '属性17';
comment on column ${idl_schema}.ref_asset_bus_breed.attr18 is '属性18';
comment on column ${idl_schema}.ref_asset_bus_breed.attr19 is '属性19';
comment on column ${idl_schema}.ref_asset_bus_breed.attr20 is '属性20';
comment on column ${idl_schema}.ref_asset_bus_breed.attr21 is '属性21';
comment on column ${idl_schema}.ref_asset_bus_breed.attr22 is '属性22';
comment on column ${idl_schema}.ref_asset_bus_breed.attr23 is '属性23';
comment on column ${idl_schema}.ref_asset_bus_breed.attr24 is '属性24';
comment on column ${idl_schema}.ref_asset_bus_breed.attr25 is '属性25';
comment on column ${idl_schema}.ref_asset_bus_breed.use_flg is '使用标志';
comment on column ${idl_schema}.ref_asset_bus_breed.loan_size_ctrl_flg is '贷款规模控制标志';
comment on column ${idl_schema}.ref_asset_bus_breed.prod_catlg_id is '产品目录编号';
comment on column ${idl_schema}.ref_asset_bus_breed.create_dt is '创建日期';
comment on column ${idl_schema}.ref_asset_bus_breed.update_dt is '更新日期';
comment on column ${idl_schema}.ref_asset_bus_breed.id_mark is '删除标识';