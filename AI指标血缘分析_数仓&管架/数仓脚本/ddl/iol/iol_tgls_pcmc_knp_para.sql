/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol tgls_pcmc_knp_para
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.tgls_pcmc_knp_para
whenever sqlerror continue none;
drop table ${iol_schema}.tgls_pcmc_knp_para purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.tgls_pcmc_knp_para(
    subscd varchar2(6) -- 子系统编码
    ,paratp varchar2(30) -- 参数类型
    ,paracd varchar2(20) -- 参数编码
    ,corpcode varchar2(16) -- 法人编码
    ,parana varchar2(80) -- 参数描述
    ,paraam number(8) -- 金额参数
    ,paradt date -- 日期参数
    ,parach varchar2(64) -- 扩展参数A
    ,parbch varchar2(64) -- 扩展参数B
    ,parcch varchar2(64) -- 扩展参数C
    ,pardch varchar2(64) -- 扩展参数D
    ,parech varchar2(64) -- 扩展参数E
    ,sortno number(10) -- 排序号
    ,area_no_str varchar2(300) -- 区域编码（无效字段）
    ,i18n_code varchar2(100) -- 国际化资源编码
    ,disable varchar2(8) -- 是否禁用，1禁用optd标签不受影响，其他标签会过滤掉禁用的
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
grant select on ${iol_schema}.tgls_pcmc_knp_para to ${iml_schema};
grant select on ${iol_schema}.tgls_pcmc_knp_para to ${icl_schema};
grant select on ${iol_schema}.tgls_pcmc_knp_para to ${idl_schema};
grant select on ${iol_schema}.tgls_pcmc_knp_para to ${iel_schema};

-- comment
comment on table ${iol_schema}.tgls_pcmc_knp_para is '系统业务字典表';
comment on column ${iol_schema}.tgls_pcmc_knp_para.subscd is '子系统编码';
comment on column ${iol_schema}.tgls_pcmc_knp_para.paratp is '参数类型';
comment on column ${iol_schema}.tgls_pcmc_knp_para.paracd is '参数编码';
comment on column ${iol_schema}.tgls_pcmc_knp_para.corpcode is '法人编码';
comment on column ${iol_schema}.tgls_pcmc_knp_para.parana is '参数描述';
comment on column ${iol_schema}.tgls_pcmc_knp_para.paraam is '金额参数';
comment on column ${iol_schema}.tgls_pcmc_knp_para.paradt is '日期参数';
comment on column ${iol_schema}.tgls_pcmc_knp_para.parach is '扩展参数A';
comment on column ${iol_schema}.tgls_pcmc_knp_para.parbch is '扩展参数B';
comment on column ${iol_schema}.tgls_pcmc_knp_para.parcch is '扩展参数C';
comment on column ${iol_schema}.tgls_pcmc_knp_para.pardch is '扩展参数D';
comment on column ${iol_schema}.tgls_pcmc_knp_para.parech is '扩展参数E';
comment on column ${iol_schema}.tgls_pcmc_knp_para.sortno is '排序号';
comment on column ${iol_schema}.tgls_pcmc_knp_para.area_no_str is '区域编码（无效字段）';
comment on column ${iol_schema}.tgls_pcmc_knp_para.i18n_code is '国际化资源编码';
comment on column ${iol_schema}.tgls_pcmc_knp_para.disable is '是否禁用，1禁用optd标签不受影响，其他标签会过滤掉禁用的';
comment on column ${iol_schema}.tgls_pcmc_knp_para.start_dt is '开始时间';
comment on column ${iol_schema}.tgls_pcmc_knp_para.end_dt is '结束时间';
comment on column ${iol_schema}.tgls_pcmc_knp_para.id_mark is '增删标志';
comment on column ${iol_schema}.tgls_pcmc_knp_para.etl_timestamp is 'ETL处理时间戳';
