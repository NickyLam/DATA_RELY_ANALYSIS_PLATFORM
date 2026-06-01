/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol cqss_i_r_competence
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.cqss_i_r_competence
whenever sqlerror continue none;
drop table ${iol_schema}.cqss_i_r_competence purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.cqss_i_r_competence(
    id varchar2(96) -- 代码主键
    ,msgidno varchar2(53) -- 报文标识号
    ,cr_ocp_qua_nm varchar2(270) -- 征信职业资格名称:pf07aq01
    ,inst_nm varchar2(360) -- 机构名称:pf07aq02
    ,cr_ocp_qua_grd_cd varchar2(90) -- 征信职业资格等级代码:pf07ad01
    ,cr_ocp_qua_inst_lo varchar2(450) -- 征信职业资格机构所在地:pf07ad02
    ,cr_ocp_qua_obtn_yrmo varchar2(11) -- 征信职业资格获得年月:pf07ar01
    ,cr_ocp_qua_exp_yrmo varchar2(11) -- 征信职业资格到期年月:pf07ar02
    ,cr_ocp_qua_lout_yrmo varchar2(11) -- 征信职业资格注销年月:pf07ar03
    ,annttn_and_sttmnt_num number(22) -- 标注及声明个数:pf07zs01
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
grant select on ${iol_schema}.cqss_i_r_competence to ${iml_schema};
grant select on ${iol_schema}.cqss_i_r_competence to ${icl_schema};
grant select on ${iol_schema}.cqss_i_r_competence to ${idl_schema};
grant select on ${iol_schema}.cqss_i_r_competence to ${iel_schema};

-- comment
comment on table ${iol_schema}.cqss_i_r_competence is '二代执业资格记录信息';
comment on column ${iol_schema}.cqss_i_r_competence.id is '代码主键';
comment on column ${iol_schema}.cqss_i_r_competence.msgidno is '报文标识号';
comment on column ${iol_schema}.cqss_i_r_competence.cr_ocp_qua_nm is '征信职业资格名称:pf07aq01';
comment on column ${iol_schema}.cqss_i_r_competence.inst_nm is '机构名称:pf07aq02';
comment on column ${iol_schema}.cqss_i_r_competence.cr_ocp_qua_grd_cd is '征信职业资格等级代码:pf07ad01';
comment on column ${iol_schema}.cqss_i_r_competence.cr_ocp_qua_inst_lo is '征信职业资格机构所在地:pf07ad02';
comment on column ${iol_schema}.cqss_i_r_competence.cr_ocp_qua_obtn_yrmo is '征信职业资格获得年月:pf07ar01';
comment on column ${iol_schema}.cqss_i_r_competence.cr_ocp_qua_exp_yrmo is '征信职业资格到期年月:pf07ar02';
comment on column ${iol_schema}.cqss_i_r_competence.cr_ocp_qua_lout_yrmo is '征信职业资格注销年月:pf07ar03';
comment on column ${iol_schema}.cqss_i_r_competence.annttn_and_sttmnt_num is '标注及声明个数:pf07zs01';
comment on column ${iol_schema}.cqss_i_r_competence.multi_tenancy_id is '多实体标识';
comment on column ${iol_schema}.cqss_i_r_competence.crt_dt_tm is '创建日期时间';
comment on column ${iol_schema}.cqss_i_r_competence.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.cqss_i_r_competence.etl_timestamp is 'ETL处理时间戳';
