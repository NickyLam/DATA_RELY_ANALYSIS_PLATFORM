/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol isbs_git
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.isbs_git
whenever sqlerror continue none;
drop table ${iol_schema}.isbs_git purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.isbs_git(
    inr varchar2(12) -- 进口信用证id号
    ,ver varchar2(6) -- 版本号
    ,covgodsrv varchar2(4000) -- 遮盖物
    ,gidtxt varchar2(4000) -- 保函文本
    ,gtxgidtxt varchar2(4000) -- 保函文本显示规则
    ,gidtxtame varchar2(4000) -- 改正历史
    ,orcplc varchar2(216) -- 初始交易地点
    ,addinf varchar2(1080) -- 附加信息
    ,revtxt varchar2(4000) -- 文本信息
    ,fldmodblk varchar2(4000) -- 修改信息
    ,apprul varchar2(6) -- 适用的国际惯例
    ,apprultxt varchar2(53) -- 国际惯例内容具体描述
    ,contag72 varchar2(4000) -- 72场的内容
    ,contag79 varchar2(4000) -- 79场的内容
    ,addamtcov varchar2(216) -- 保证金附加额
    ,chaded varchar2(324) -- 报文71场内容
    ,amtspc varchar2(216) -- 报文39场内容
    ,accspc varchar2(53) -- 报文25场内容
    ,decamtstm varchar2(4000) -- 减额金额
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
grant select on ${iol_schema}.isbs_git to ${iml_schema};
grant select on ${iol_schema}.isbs_git to ${icl_schema};
grant select on ${iol_schema}.isbs_git to ${idl_schema};
grant select on ${iol_schema}.isbs_git to ${iel_schema};

-- comment
comment on table ${iol_schema}.isbs_git is '保函业务信息(存放长字节)';
comment on column ${iol_schema}.isbs_git.inr is '进口信用证id号';
comment on column ${iol_schema}.isbs_git.ver is '版本号';
comment on column ${iol_schema}.isbs_git.covgodsrv is '遮盖物';
comment on column ${iol_schema}.isbs_git.gidtxt is '保函文本';
comment on column ${iol_schema}.isbs_git.gtxgidtxt is '保函文本显示规则';
comment on column ${iol_schema}.isbs_git.gidtxtame is '改正历史';
comment on column ${iol_schema}.isbs_git.orcplc is '初始交易地点';
comment on column ${iol_schema}.isbs_git.addinf is '附加信息';
comment on column ${iol_schema}.isbs_git.revtxt is '文本信息';
comment on column ${iol_schema}.isbs_git.fldmodblk is '修改信息';
comment on column ${iol_schema}.isbs_git.apprul is '适用的国际惯例';
comment on column ${iol_schema}.isbs_git.apprultxt is '国际惯例内容具体描述';
comment on column ${iol_schema}.isbs_git.contag72 is '72场的内容';
comment on column ${iol_schema}.isbs_git.contag79 is '79场的内容';
comment on column ${iol_schema}.isbs_git.addamtcov is '保证金附加额';
comment on column ${iol_schema}.isbs_git.chaded is '报文71场内容';
comment on column ${iol_schema}.isbs_git.amtspc is '报文39场内容';
comment on column ${iol_schema}.isbs_git.accspc is '报文25场内容';
comment on column ${iol_schema}.isbs_git.decamtstm is '减额金额';
comment on column ${iol_schema}.isbs_git.start_dt is '开始时间';
comment on column ${iol_schema}.isbs_git.end_dt is '结束时间';
comment on column ${iol_schema}.isbs_git.id_mark is '增删标志';
comment on column ${iol_schema}.isbs_git.etl_timestamp is 'ETL处理时间戳';
