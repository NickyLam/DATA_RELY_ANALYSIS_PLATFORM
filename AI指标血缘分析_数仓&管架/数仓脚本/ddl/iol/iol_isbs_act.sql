/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol isbs_act
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.isbs_act
whenever sqlerror continue none;
drop table ${iol_schema}.isbs_act purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.isbs_act(
    inr varchar2(12) -- 唯一id号，主键
    ,pri varchar2(2) -- 账号优先级
    ,cur varchar2(5) -- 账号币种
    ,extkey varchar2(51) -- 账号
    ,seracc varchar2(51) -- 账号提供机构的账号
    ,sernam varchar2(60) -- 账号提供机构名称
    ,serptytyp varchar2(2) -- 账号提供机构种类
    ,serptyinr varchar2(12) -- 账号提供机构inr号
    ,holacc varchar2(51) -- 账号开户机构的账号
    ,holnam varchar2(60) -- 账号开户机构名称
    ,holptytyp varchar2(2) -- 账号开户机构类型
    ,holptyinr varchar2(12) -- 账号开户机构inr号
    ,cvrflg varchar2(2) -- 头寸账户标志
    ,rmbflg varchar2(2) -- 偿付账户标志
    ,delflg varchar2(2) -- 已删账户标志
    ,ver varchar2(6) -- 版本文本
    ,dirflg varchar2(2) -- 借贷标志
    ,othbnkflg varchar2(2) -- 是否账户行账号标志
    ,othptynam varchar2(60) -- 账户行名称
    ,othownflg varchar2(2) -- 是否我方账户行标志
    ,othbic6 varchar2(9) -- 账户行的6位bic
    ,iban varchar2(51) -- 国际银行账户号
    ,etgextkey varchar2(12) -- 实体组
    ,nam varchar2(60) -- 账号名称
    ,exttyp varchar2(5) -- 外部账号类型
    ,typ varchar2(5) -- 账号类型
    ,extact varchar2(12) -- 外部账号
    ,trmtyp varchar2(9) -- 科目代码
    ,acctyp varchar2(2) -- 账户类型
    ,bchkeyinr varchar2(12) -- 所属机构inr
    ,othbic varchar2(17) -- 银行编号
    ,cshflg varchar2(2) -- 现金标记
    ,nam1 varchar2(120) -- 产品名称
    ,wgzhxz varchar2(60) -- 外管账户性质
    ,banktyp varchar2(5) -- 银行类型
    ,prdtyp varchar2(18) -- 产品类型
    ,seqno varchar2(8) -- 账户序列号
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
grant select on ${iol_schema}.isbs_act to ${iml_schema};
grant select on ${iol_schema}.isbs_act to ${icl_schema};
grant select on ${iol_schema}.isbs_act to ${idl_schema};
grant select on ${iol_schema}.isbs_act to ${iel_schema};

-- comment
comment on table ${iol_schema}.isbs_act is '帐号信息';
comment on column ${iol_schema}.isbs_act.inr is '唯一id号，主键';
comment on column ${iol_schema}.isbs_act.pri is '账号优先级';
comment on column ${iol_schema}.isbs_act.cur is '账号币种';
comment on column ${iol_schema}.isbs_act.extkey is '账号';
comment on column ${iol_schema}.isbs_act.seracc is '账号提供机构的账号';
comment on column ${iol_schema}.isbs_act.sernam is '账号提供机构名称';
comment on column ${iol_schema}.isbs_act.serptytyp is '账号提供机构种类';
comment on column ${iol_schema}.isbs_act.serptyinr is '账号提供机构inr号';
comment on column ${iol_schema}.isbs_act.holacc is '账号开户机构的账号';
comment on column ${iol_schema}.isbs_act.holnam is '账号开户机构名称';
comment on column ${iol_schema}.isbs_act.holptytyp is '账号开户机构类型';
comment on column ${iol_schema}.isbs_act.holptyinr is '账号开户机构inr号';
comment on column ${iol_schema}.isbs_act.cvrflg is '头寸账户标志';
comment on column ${iol_schema}.isbs_act.rmbflg is '偿付账户标志';
comment on column ${iol_schema}.isbs_act.delflg is '已删账户标志';
comment on column ${iol_schema}.isbs_act.ver is '版本文本';
comment on column ${iol_schema}.isbs_act.dirflg is '借贷标志';
comment on column ${iol_schema}.isbs_act.othbnkflg is '是否账户行账号标志';
comment on column ${iol_schema}.isbs_act.othptynam is '账户行名称';
comment on column ${iol_schema}.isbs_act.othownflg is '是否我方账户行标志';
comment on column ${iol_schema}.isbs_act.othbic6 is '账户行的6位bic';
comment on column ${iol_schema}.isbs_act.iban is '国际银行账户号';
comment on column ${iol_schema}.isbs_act.etgextkey is '实体组';
comment on column ${iol_schema}.isbs_act.nam is '账号名称';
comment on column ${iol_schema}.isbs_act.exttyp is '外部账号类型';
comment on column ${iol_schema}.isbs_act.typ is '账号类型';
comment on column ${iol_schema}.isbs_act.extact is '外部账号';
comment on column ${iol_schema}.isbs_act.trmtyp is '科目代码';
comment on column ${iol_schema}.isbs_act.acctyp is '账户类型';
comment on column ${iol_schema}.isbs_act.bchkeyinr is '所属机构inr';
comment on column ${iol_schema}.isbs_act.othbic is '银行编号';
comment on column ${iol_schema}.isbs_act.cshflg is '现金标记';
comment on column ${iol_schema}.isbs_act.nam1 is '产品名称';
comment on column ${iol_schema}.isbs_act.wgzhxz is '外管账户性质';
comment on column ${iol_schema}.isbs_act.banktyp is '银行类型';
comment on column ${iol_schema}.isbs_act.prdtyp is '产品类型';
comment on column ${iol_schema}.isbs_act.seqno is '账户序列号';
comment on column ${iol_schema}.isbs_act.start_dt is '开始时间';
comment on column ${iol_schema}.isbs_act.end_dt is '结束时间';
comment on column ${iol_schema}.isbs_act.id_mark is '增删标志';
comment on column ${iol_schema}.isbs_act.etl_timestamp is 'ETL处理时间戳';
