/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol isbs_pts
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.isbs_pts
whenever sqlerror continue none;
drop table ${iol_schema}.isbs_pts purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.isbs_pts(
    inr varchar2(12) -- 内部唯一id号
    ,objtyp varchar2(9) -- 联系实体类型
    ,objinr varchar2(12) -- 联系实体inr
    ,rol varchar2(5) -- 角色类型
    ,ptainr varchar2(12) -- 关联地址的inr
    ,ptyinr varchar2(12) -- 关联当事人inr
    ,extkey varchar2(24) -- 联系地址外部关键字
    ,adrblk varchar2(216) -- 地址信息
    ,ref varchar2(24) -- 地址参考
    ,nam varchar2(60) -- 当事人基本名称
    ,ownref varchar2(30) -- 交易参考号和角色
    ,dftcur varchar2(5) -- 默认货币种类
    ,dftdsp varchar2(5) -- 默认的角色等级
    ,dftact varchar2(51) -- 默认账户种类
    ,dftfeecur varchar2(5) -- 默认费用使用的货币种类
    ,dftactptainr varchar2(12) -- 默认帐户
    ,glggrpflg varchar2(5) -- 费用合计方式标志
    ,extact varchar2(51) -- 帐号
    ,ver varchar2(6) -- 版本号
    ,bankno varchar2(12) -- 银行号
    ,issbaninf varchar2(60) -- 
    ,adrblkcn varchar2(246) -- 
    ,bankno1 varchar2(30) -- 人行行号
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
grant select on ${iol_schema}.isbs_pts to ${iml_schema};
grant select on ${iol_schema}.isbs_pts to ${icl_schema};
grant select on ${iol_schema}.isbs_pts to ${idl_schema};
grant select on ${iol_schema}.isbs_pts to ${iel_schema};

-- comment
comment on table ${iol_schema}.isbs_pts is '每笔业务涉及到的Party信息';
comment on column ${iol_schema}.isbs_pts.inr is '内部唯一id号';
comment on column ${iol_schema}.isbs_pts.objtyp is '联系实体类型';
comment on column ${iol_schema}.isbs_pts.objinr is '联系实体inr';
comment on column ${iol_schema}.isbs_pts.rol is '角色类型';
comment on column ${iol_schema}.isbs_pts.ptainr is '关联地址的inr';
comment on column ${iol_schema}.isbs_pts.ptyinr is '关联当事人inr';
comment on column ${iol_schema}.isbs_pts.extkey is '联系地址外部关键字';
comment on column ${iol_schema}.isbs_pts.adrblk is '地址信息';
comment on column ${iol_schema}.isbs_pts.ref is '地址参考';
comment on column ${iol_schema}.isbs_pts.nam is '当事人基本名称';
comment on column ${iol_schema}.isbs_pts.ownref is '交易参考号和角色';
comment on column ${iol_schema}.isbs_pts.dftcur is '默认货币种类';
comment on column ${iol_schema}.isbs_pts.dftdsp is '默认的角色等级';
comment on column ${iol_schema}.isbs_pts.dftact is '默认账户种类';
comment on column ${iol_schema}.isbs_pts.dftfeecur is '默认费用使用的货币种类';
comment on column ${iol_schema}.isbs_pts.dftactptainr is '默认帐户';
comment on column ${iol_schema}.isbs_pts.glggrpflg is '费用合计方式标志';
comment on column ${iol_schema}.isbs_pts.extact is '帐号';
comment on column ${iol_schema}.isbs_pts.ver is '版本号';
comment on column ${iol_schema}.isbs_pts.bankno is '银行号';
comment on column ${iol_schema}.isbs_pts.issbaninf is '';
comment on column ${iol_schema}.isbs_pts.adrblkcn is '';
comment on column ${iol_schema}.isbs_pts.bankno1 is '人行行号';
comment on column ${iol_schema}.isbs_pts.start_dt is '开始时间';
comment on column ${iol_schema}.isbs_pts.end_dt is '结束时间';
comment on column ${iol_schema}.isbs_pts.id_mark is '增删标志';
comment on column ${iol_schema}.isbs_pts.etl_timestamp is 'ETL处理时间戳';
