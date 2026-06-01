/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol cqss_e_r_important_prompt
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.cqss_e_r_important_prompt
whenever sqlerror continue none;
drop table ${iol_schema}.cqss_e_r_important_prompt purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.cqss_e_r_important_prompt(
    id varchar2(96) -- 代码主键
    ,pbc_fnc_inst_ecd varchar2(21) -- 人民银行金融机构编码
    ,entp_idnt_idr_tp varchar2(3) -- 企业身份标识类型
    ,entp_idnt_idr_no varchar2(180) -- 企业身份标识号码
    ,entp_impt_prmpt_cd varchar2(8) -- 企业重要信息提示代码
    ,inf_udt_tm date -- 信息更新时间
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
grant select on ${iol_schema}.cqss_e_r_important_prompt to ${iml_schema};
grant select on ${iol_schema}.cqss_e_r_important_prompt to ${icl_schema};
grant select on ${iol_schema}.cqss_e_r_important_prompt to ${idl_schema};
grant select on ${iol_schema}.cqss_e_r_important_prompt to ${iel_schema};

-- comment
comment on table ${iol_schema}.cqss_e_r_important_prompt is '企业重要信息提示表';
comment on column ${iol_schema}.cqss_e_r_important_prompt.id is '代码主键';
comment on column ${iol_schema}.cqss_e_r_important_prompt.pbc_fnc_inst_ecd is '人民银行金融机构编码';
comment on column ${iol_schema}.cqss_e_r_important_prompt.entp_idnt_idr_tp is '企业身份标识类型';
comment on column ${iol_schema}.cqss_e_r_important_prompt.entp_idnt_idr_no is '企业身份标识号码';
comment on column ${iol_schema}.cqss_e_r_important_prompt.entp_impt_prmpt_cd is '企业重要信息提示代码';
comment on column ${iol_schema}.cqss_e_r_important_prompt.inf_udt_tm is '信息更新时间';
comment on column ${iol_schema}.cqss_e_r_important_prompt.crt_dt_tm is '创建日期时间';
comment on column ${iol_schema}.cqss_e_r_important_prompt.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.cqss_e_r_important_prompt.etl_timestamp is 'ETL处理时间戳';
