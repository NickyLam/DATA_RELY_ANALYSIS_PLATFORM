/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol isbs_rptcod
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.isbs_rptcod
whenever sqlerror continue none;
drop table ${iol_schema}.isbs_rptcod purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.isbs_rptcod(
    inr varchar2(24) -- 主键
    ,trninr varchar2(24) -- TRN表关联主键
    ,ownref varchar2(48) -- 业务编号
    ,djdate date -- 登记日期
    ,djtime timestamp -- 登记时间
    ,fincod varchar2(96) -- 借据号
    ,docid varchar2(90) -- 单据ID
    ,creextkey varchar2(48) -- 创建客户ID
    ,doccur varchar2(9) -- 币种
    ,docamt number(18,3) -- 金额
    ,doctyp varchar2(36) -- 单据类型
    ,bchkeyinr varchar2(36) -- 经办机构INR
    ,crefrm varchar2(18) -- 创建交易
    ,intyp varchar2(15) -- 导入方式
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
grant select on ${iol_schema}.isbs_rptcod to ${iml_schema};
grant select on ${iol_schema}.isbs_rptcod to ${icl_schema};
grant select on ${iol_schema}.isbs_rptcod to ${idl_schema};
grant select on ${iol_schema}.isbs_rptcod to ${iel_schema};

-- comment
comment on table ${iol_schema}.isbs_rptcod is '商业单据信息表';
comment on column ${iol_schema}.isbs_rptcod.inr is '主键';
comment on column ${iol_schema}.isbs_rptcod.trninr is 'TRN表关联主键';
comment on column ${iol_schema}.isbs_rptcod.ownref is '业务编号';
comment on column ${iol_schema}.isbs_rptcod.djdate is '登记日期';
comment on column ${iol_schema}.isbs_rptcod.djtime is '登记时间';
comment on column ${iol_schema}.isbs_rptcod.fincod is '借据号';
comment on column ${iol_schema}.isbs_rptcod.docid is '单据ID';
comment on column ${iol_schema}.isbs_rptcod.creextkey is '创建客户ID';
comment on column ${iol_schema}.isbs_rptcod.doccur is '币种';
comment on column ${iol_schema}.isbs_rptcod.docamt is '金额';
comment on column ${iol_schema}.isbs_rptcod.doctyp is '单据类型';
comment on column ${iol_schema}.isbs_rptcod.bchkeyinr is '经办机构INR';
comment on column ${iol_schema}.isbs_rptcod.crefrm is '创建交易';
comment on column ${iol_schema}.isbs_rptcod.intyp is '导入方式';
comment on column ${iol_schema}.isbs_rptcod.start_dt is '开始时间';
comment on column ${iol_schema}.isbs_rptcod.end_dt is '结束时间';
comment on column ${iol_schema}.isbs_rptcod.id_mark is '增删标志';
comment on column ${iol_schema}.isbs_rptcod.etl_timestamp is 'ETL处理时间戳';
