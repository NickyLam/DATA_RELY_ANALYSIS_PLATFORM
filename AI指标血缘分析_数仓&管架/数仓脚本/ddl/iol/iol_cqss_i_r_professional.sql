/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol cqss_i_r_professional
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.cqss_i_r_professional
whenever sqlerror continue none;
drop table ${iol_schema}.cqss_i_r_professional purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.cqss_i_r_professional(
    id varchar2(96) -- 代码主键
    ,msgidno varchar2(53) -- 报文标识号
    ,pbc_cr_emp_sttn varchar2(3) -- 人行征信就业状况:pb040d01
    ,wrk_unit_nm varchar2(360) -- 工作单位名称:pb040q01
    ,pbc_cr_unit_char varchar2(3) -- 人行征信单位性质:pb040d02
    ,idy_cd varchar2(8) -- 行业代码:pb040d03
    ,cr_rsdnc_adr varchar2(450) -- 征信居住地址:pb040q02
    ,move_telno varchar2(113) -- 移动电话号码:pb040q03
    ,pbc_cr_ocp varchar2(2) -- 人行征信职业:pb040d04
    ,pbc_cr_post varchar2(2) -- 人行征信职务:pb040d05
    ,pbc_cr_ttl varchar2(2) -- 人行征信职称:pb040d06
    ,entr_crnco_wkdy_prd date -- 进入现单位工作日期:pb040r01
    ,cr_inf_udt_dt date -- 征信信息更新日期:pb040r02
    ,multi_tenancy_id varchar2(30) -- 多实体标识
    ,crt_dt_tm date -- 创建日期时间:
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
grant select on ${iol_schema}.cqss_i_r_professional to ${iml_schema};
grant select on ${iol_schema}.cqss_i_r_professional to ${icl_schema};
grant select on ${iol_schema}.cqss_i_r_professional to ${idl_schema};
grant select on ${iol_schema}.cqss_i_r_professional to ${iel_schema};

-- comment
comment on table ${iol_schema}.cqss_i_r_professional is '二代职业信息';
comment on column ${iol_schema}.cqss_i_r_professional.id is '代码主键';
comment on column ${iol_schema}.cqss_i_r_professional.msgidno is '报文标识号';
comment on column ${iol_schema}.cqss_i_r_professional.pbc_cr_emp_sttn is '人行征信就业状况:pb040d01';
comment on column ${iol_schema}.cqss_i_r_professional.wrk_unit_nm is '工作单位名称:pb040q01';
comment on column ${iol_schema}.cqss_i_r_professional.pbc_cr_unit_char is '人行征信单位性质:pb040d02';
comment on column ${iol_schema}.cqss_i_r_professional.idy_cd is '行业代码:pb040d03';
comment on column ${iol_schema}.cqss_i_r_professional.cr_rsdnc_adr is '征信居住地址:pb040q02';
comment on column ${iol_schema}.cqss_i_r_professional.move_telno is '移动电话号码:pb040q03';
comment on column ${iol_schema}.cqss_i_r_professional.pbc_cr_ocp is '人行征信职业:pb040d04';
comment on column ${iol_schema}.cqss_i_r_professional.pbc_cr_post is '人行征信职务:pb040d05';
comment on column ${iol_schema}.cqss_i_r_professional.pbc_cr_ttl is '人行征信职称:pb040d06';
comment on column ${iol_schema}.cqss_i_r_professional.entr_crnco_wkdy_prd is '进入现单位工作日期:pb040r01';
comment on column ${iol_schema}.cqss_i_r_professional.cr_inf_udt_dt is '征信信息更新日期:pb040r02';
comment on column ${iol_schema}.cqss_i_r_professional.multi_tenancy_id is '多实体标识';
comment on column ${iol_schema}.cqss_i_r_professional.crt_dt_tm is '创建日期时间:';
comment on column ${iol_schema}.cqss_i_r_professional.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.cqss_i_r_professional.etl_timestamp is 'ETL处理时间戳';
