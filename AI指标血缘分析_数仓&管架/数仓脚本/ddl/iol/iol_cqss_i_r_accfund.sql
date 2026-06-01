/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol cqss_i_r_accfund
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.cqss_i_r_accfund
whenever sqlerror continue none;
drop table ${iol_schema}.cqss_i_r_accfund purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.cqss_i_r_accfund(
    id varchar2(96) -- 代码主键
    ,msgidno varchar2(53) -- 报文标识号
    ,crprvdfnd_pcp_pyf_adr varchar2(450) -- 征信公积金参加缴费地址:pf05aq01
    ,cr_prvdfnd_pcp_pyf_dt date -- 征信公积金参加缴费日期:pf05ar01
    ,cr_hsgrsvfnd_pyf_stcd varchar2(30) -- 征信住房公积金缴费状态代码:pf05ad01
    ,crprvdfnd_ftm_pymt_dt varchar2(11) -- 征信公积金首次缴交日期:pf05ar02
    ,hsgrsvfnd_pyt_yrmo varchar2(11) -- 住房公积金缴至年月:pf05ar03
    ,prvdfndunit_depd_pctg number(22) -- 公积金单位缴存比例:pf05aq02
    ,prvdfnd_idv_depd_pctg number(22) -- 公积金个人缴存比例:pf05aq03
    ,cr_prvdfnd_mo_pym_amt number(38,0) -- 征信公积金月缴款总金额:pf05aj01
    ,prvdfnd_unit_nm varchar2(360) -- 公积金单位名称:pf05aq04
    ,cr_inf_udt_dt date -- 征信信息更新日期:pf05ar04
    ,annttn_and_sttmnt_num number(22) -- 标注及声明个数:pf05zs01
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
grant select on ${iol_schema}.cqss_i_r_accfund to ${iml_schema};
grant select on ${iol_schema}.cqss_i_r_accfund to ${icl_schema};
grant select on ${iol_schema}.cqss_i_r_accfund to ${idl_schema};
grant select on ${iol_schema}.cqss_i_r_accfund to ${iel_schema};

-- comment
comment on table ${iol_schema}.cqss_i_r_accfund is '二代住房公积金参缴记录';
comment on column ${iol_schema}.cqss_i_r_accfund.id is '代码主键';
comment on column ${iol_schema}.cqss_i_r_accfund.msgidno is '报文标识号';
comment on column ${iol_schema}.cqss_i_r_accfund.crprvdfnd_pcp_pyf_adr is '征信公积金参加缴费地址:pf05aq01';
comment on column ${iol_schema}.cqss_i_r_accfund.cr_prvdfnd_pcp_pyf_dt is '征信公积金参加缴费日期:pf05ar01';
comment on column ${iol_schema}.cqss_i_r_accfund.cr_hsgrsvfnd_pyf_stcd is '征信住房公积金缴费状态代码:pf05ad01';
comment on column ${iol_schema}.cqss_i_r_accfund.crprvdfnd_ftm_pymt_dt is '征信公积金首次缴交日期:pf05ar02';
comment on column ${iol_schema}.cqss_i_r_accfund.hsgrsvfnd_pyt_yrmo is '住房公积金缴至年月:pf05ar03';
comment on column ${iol_schema}.cqss_i_r_accfund.prvdfndunit_depd_pctg is '公积金单位缴存比例:pf05aq02';
comment on column ${iol_schema}.cqss_i_r_accfund.prvdfnd_idv_depd_pctg is '公积金个人缴存比例:pf05aq03';
comment on column ${iol_schema}.cqss_i_r_accfund.cr_prvdfnd_mo_pym_amt is '征信公积金月缴款总金额:pf05aj01';
comment on column ${iol_schema}.cqss_i_r_accfund.prvdfnd_unit_nm is '公积金单位名称:pf05aq04';
comment on column ${iol_schema}.cqss_i_r_accfund.cr_inf_udt_dt is '征信信息更新日期:pf05ar04';
comment on column ${iol_schema}.cqss_i_r_accfund.annttn_and_sttmnt_num is '标注及声明个数:pf05zs01';
comment on column ${iol_schema}.cqss_i_r_accfund.multi_tenancy_id is '多实体标识';
comment on column ${iol_schema}.cqss_i_r_accfund.crt_dt_tm is '创建日期时间';
comment on column ${iol_schema}.cqss_i_r_accfund.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.cqss_i_r_accfund.etl_timestamp is 'ETL处理时间戳';
