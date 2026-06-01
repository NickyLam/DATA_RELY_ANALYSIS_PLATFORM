/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol pams_dxgx_hyyjgx_lxd
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.pams_dxgx_hyyjgx_lxd
whenever sqlerror continue none;
drop table ${iol_schema}.pams_dxgx_hyyjgx_lxd purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.pams_dxgx_hyyjgx_lxd(
    jxdxdh number(22,0) -- 
    ,khdxdh number(22,0) -- 
    ,fpjs varchar2(3) -- 
    ,qsrq number(22,0) -- 起始日期
    ,jsrq number(22,0) -- 结束日期
    ,gxhslx varchar2(2) -- 
    ,yz number(25,4) -- 
    ,clbl number(19,5) -- 
    ,zlbl number(19,5) -- 
    ,gxly varchar2(3) -- 
    ,yylsh number(20,0) -- 
    ,gxzt varchar2(2) -- 
    ,start_dt date -- 开始时间
    ,end_dt date -- 结束时间
    ,id_mark varchar2(10) -- 增删标志
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list(end_dt)(
     partition p_19000101 values (to_date('19000101','yyyymmdd')),
     partition p_20991231 values (to_date('20991231','yyyymmdd'))
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${iol_schema}.pams_dxgx_hyyjgx_lxd to ${iml_schema};
grant select on ${iol_schema}.pams_dxgx_hyyjgx_lxd to ${icl_schema};
grant select on ${iol_schema}.pams_dxgx_hyyjgx_lxd to ${idl_schema};
grant select on ${iol_schema}.pams_dxgx_hyyjgx_lxd to ${iel_schema};

-- comment
comment on table ${iol_schema}.pams_dxgx_hyyjgx_lxd is '对象关系行员业绩关系类信贷';
comment on column ${iol_schema}.pams_dxgx_hyyjgx_lxd.jxdxdh is '';
comment on column ${iol_schema}.pams_dxgx_hyyjgx_lxd.khdxdh is '';
comment on column ${iol_schema}.pams_dxgx_hyyjgx_lxd.fpjs is '';
comment on column ${iol_schema}.pams_dxgx_hyyjgx_lxd.qsrq is '起始日期';
comment on column ${iol_schema}.pams_dxgx_hyyjgx_lxd.jsrq is '结束日期';
comment on column ${iol_schema}.pams_dxgx_hyyjgx_lxd.gxhslx is '';
comment on column ${iol_schema}.pams_dxgx_hyyjgx_lxd.yz is '';
comment on column ${iol_schema}.pams_dxgx_hyyjgx_lxd.clbl is '';
comment on column ${iol_schema}.pams_dxgx_hyyjgx_lxd.zlbl is '';
comment on column ${iol_schema}.pams_dxgx_hyyjgx_lxd.gxly is '';
comment on column ${iol_schema}.pams_dxgx_hyyjgx_lxd.yylsh is '';
comment on column ${iol_schema}.pams_dxgx_hyyjgx_lxd.gxzt is '';
comment on column ${iol_schema}.pams_dxgx_hyyjgx_lxd.start_dt is '开始时间';
comment on column ${iol_schema}.pams_dxgx_hyyjgx_lxd.end_dt is '结束时间';
comment on column ${iol_schema}.pams_dxgx_hyyjgx_lxd.id_mark is '增删标志';
comment on column ${iol_schema}.pams_dxgx_hyyjgx_lxd.etl_timestamp is 'ETL处理时间戳';
