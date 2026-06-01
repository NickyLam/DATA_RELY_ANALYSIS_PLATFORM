/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol cqss_i_r_forceexecution
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.cqss_i_r_forceexecution
whenever sqlerror continue none;
drop table ${iol_schema}.cqss_i_r_forceexecution purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.cqss_i_r_forceexecution(
    id varchar2(96) -- 代码主键
    ,msgidno varchar2(53) -- 报文标识号
    ,exec_court_nm varchar2(360) -- 执行法院名称:pf03aq01
    ,crefrcexe_exec_cs_rsn varchar2(180) -- 征信强制执行执行案件原因:pf03aq02
    ,cr_jdgmt_putonrcrd_dt date -- 征信判决立案日期:pf03ar01
    ,crefrcexe_endcs_mtdcd varchar2(900) -- 征信强制执行结案方式代码:pf03ad01
    ,cr_efrcexe_cs_st varchar2(90) -- 征信强制执行案件状态:pf03aq03
    ,endcs_dt date -- 结案日期:pf03ar02
    ,cr_efrcexe_ayexc_obj varchar2(900) -- 征信强制执行申请执行标的:pf03aq04
    ,crefrcexeayexcobj_amt number(38,0) -- 征信强制执行申请执行标的金额:pf03aj01
    ,crefrcexealrdyexecobj varchar2(900) -- 征信强制执行已执行标的:pf03aq05
    ,crefrcexeayexecobjamt number(38,0) -- 征信强制执行已执行标的金额:pf03aj02
    ,annttn_and_sttmnt_num number(22) -- 标注及声明个数:pf03zs01
    ,multi_tenancy_id varchar2(30) -- 多实体标识
    ,crt_dt_tm date -- 创建日期时间
    ,etl_dt date -- ETL处理日期
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list(etl_dt)(
    partition p_19000101 values (to_date('19000101','yyyymmdd'))
)
storage (initial 64k next 64k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${iol_schema}.cqss_i_r_forceexecution to ${iml_schema};
grant select on ${iol_schema}.cqss_i_r_forceexecution to ${icl_schema};
grant select on ${iol_schema}.cqss_i_r_forceexecution to ${idl_schema};
grant select on ${iol_schema}.cqss_i_r_forceexecution to ${iel_schema};

-- comment
comment on table ${iol_schema}.cqss_i_r_forceexecution is '二代强制执行记录信息';
comment on column ${iol_schema}.cqss_i_r_forceexecution.id is '代码主键';
comment on column ${iol_schema}.cqss_i_r_forceexecution.msgidno is '报文标识号';
comment on column ${iol_schema}.cqss_i_r_forceexecution.exec_court_nm is '执行法院名称:pf03aq01';
comment on column ${iol_schema}.cqss_i_r_forceexecution.crefrcexe_exec_cs_rsn is '征信强制执行执行案件原因:pf03aq02';
comment on column ${iol_schema}.cqss_i_r_forceexecution.cr_jdgmt_putonrcrd_dt is '征信判决立案日期:pf03ar01';
comment on column ${iol_schema}.cqss_i_r_forceexecution.crefrcexe_endcs_mtdcd is '征信强制执行结案方式代码:pf03ad01';
comment on column ${iol_schema}.cqss_i_r_forceexecution.cr_efrcexe_cs_st is '征信强制执行案件状态:pf03aq03';
comment on column ${iol_schema}.cqss_i_r_forceexecution.endcs_dt is '结案日期:pf03ar02';
comment on column ${iol_schema}.cqss_i_r_forceexecution.cr_efrcexe_ayexc_obj is '征信强制执行申请执行标的:pf03aq04';
comment on column ${iol_schema}.cqss_i_r_forceexecution.crefrcexeayexcobj_amt is '征信强制执行申请执行标的金额:pf03aj01';
comment on column ${iol_schema}.cqss_i_r_forceexecution.crefrcexealrdyexecobj is '征信强制执行已执行标的:pf03aq05';
comment on column ${iol_schema}.cqss_i_r_forceexecution.crefrcexeayexecobjamt is '征信强制执行已执行标的金额:pf03aj02';
comment on column ${iol_schema}.cqss_i_r_forceexecution.annttn_and_sttmnt_num is '标注及声明个数:pf03zs01';
comment on column ${iol_schema}.cqss_i_r_forceexecution.multi_tenancy_id is '多实体标识';
comment on column ${iol_schema}.cqss_i_r_forceexecution.crt_dt_tm is '创建日期时间';
comment on column ${iol_schema}.cqss_i_r_forceexecution.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.cqss_i_r_forceexecution.etl_timestamp is 'ETL处理时间戳';
