/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol mpcs_a71tzctdsigninfo
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.mpcs_a71tzctdsigninfo
whenever sqlerror continue none;
drop table ${iol_schema}.mpcs_a71tzctdsigninfo purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.mpcs_a71tzctdsigninfo(
    transcode varchar2(6) -- 交易代码
    ,trxseq varchar2(64) -- 交易流水号
    ,transdt varchar2(8) -- 平台日期
    ,transtm varchar2(6) -- 平台时间
    ,mainacct varchar2(30) -- 实体主账号
    ,mainacctname varchar2(256) -- 实体主账户名
    ,custno varchar2(30) -- 客户号
    ,custname varchar2(200) -- 客户名称
    ,acctstatus varchar2(16) -- 账户状态
    ,magebrn varchar2(8) -- 开户机构
    ,instname varchar2(100) -- 开户机构名称
    ,status varchar2(2) -- 状态（0已签约 1已解约）
    ,signinstno varchar2(30) -- 签约机构号
    ,operrid varchar2(20) -- 操作员工号
    ,operrname varchar2(20) -- 操作员工姓名
    ,flag varchar2(2) -- 标志位
    ,remark varchar2(128) -- 备注
    ,remark1 varchar2(128) -- 备注1
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
grant select on ${iol_schema}.mpcs_a71tzctdsigninfo to ${iml_schema};
grant select on ${iol_schema}.mpcs_a71tzctdsigninfo to ${icl_schema};
grant select on ${iol_schema}.mpcs_a71tzctdsigninfo to ${idl_schema};
grant select on ${iol_schema}.mpcs_a71tzctdsigninfo to ${iel_schema};

-- comment
comment on table ${iol_schema}.mpcs_a71tzctdsigninfo is 'FSBZJ增城土地主账户签约信息表';
comment on column ${iol_schema}.mpcs_a71tzctdsigninfo.transcode is '交易代码';
comment on column ${iol_schema}.mpcs_a71tzctdsigninfo.trxseq is '交易流水号';
comment on column ${iol_schema}.mpcs_a71tzctdsigninfo.transdt is '平台日期';
comment on column ${iol_schema}.mpcs_a71tzctdsigninfo.transtm is '平台时间';
comment on column ${iol_schema}.mpcs_a71tzctdsigninfo.mainacct is '实体主账号';
comment on column ${iol_schema}.mpcs_a71tzctdsigninfo.mainacctname is '实体主账户名';
comment on column ${iol_schema}.mpcs_a71tzctdsigninfo.custno is '客户号';
comment on column ${iol_schema}.mpcs_a71tzctdsigninfo.custname is '客户名称';
comment on column ${iol_schema}.mpcs_a71tzctdsigninfo.acctstatus is '账户状态';
comment on column ${iol_schema}.mpcs_a71tzctdsigninfo.magebrn is '开户机构';
comment on column ${iol_schema}.mpcs_a71tzctdsigninfo.instname is '开户机构名称';
comment on column ${iol_schema}.mpcs_a71tzctdsigninfo.status is '状态（0已签约 1已解约）';
comment on column ${iol_schema}.mpcs_a71tzctdsigninfo.signinstno is '签约机构号';
comment on column ${iol_schema}.mpcs_a71tzctdsigninfo.operrid is '操作员工号';
comment on column ${iol_schema}.mpcs_a71tzctdsigninfo.operrname is '操作员工姓名';
comment on column ${iol_schema}.mpcs_a71tzctdsigninfo.flag is '标志位';
comment on column ${iol_schema}.mpcs_a71tzctdsigninfo.remark is '备注';
comment on column ${iol_schema}.mpcs_a71tzctdsigninfo.remark1 is '备注1';
comment on column ${iol_schema}.mpcs_a71tzctdsigninfo.start_dt is '开始时间';
comment on column ${iol_schema}.mpcs_a71tzctdsigninfo.end_dt is '结束时间';
comment on column ${iol_schema}.mpcs_a71tzctdsigninfo.id_mark is '增删标志';
comment on column ${iol_schema}.mpcs_a71tzctdsigninfo.etl_timestamp is 'ETL处理时间戳';
