/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol cqss_e_r_dbtcraccrepyprfmninf
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.cqss_e_r_dbtcraccrepyprfmninf
whenever sqlerror continue none;
drop table ${iol_schema}.cqss_e_r_dbtcraccrepyprfmninf purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.cqss_e_r_dbtcraccrepyprfmninf(
    id varchar2(96) -- 代码主键
    ,msgidno varchar2(53) -- 报文标识号
    ,multi_tenancy_id varchar2(30) -- 多实体标识
    ,cr_supr_rcrd_id varchar2(96) -- 征信上级记录编号(上级序号)
    ,infrpt_dt date -- 信息报告日期:ed01br01
    ,bal number(38,0) -- 余额:ed01bj01
    ,bal_chg_dt date -- 余额变化日期:ed01br02
    ,pbc_lv5cl_cd varchar2(2) -- 人行征信五级分类(五级分类):ed01bd01
    ,lv5cl_afm_dt date -- 五级分类认定日期:ed01br03
    ,rctlyocact_repydy_prd date -- 最近一次实际还款日期:ed01br04
    ,rctlyoc_act_repy_tamt number(38,0) -- 最近一次实际还款总额:ed01bj02
    ,rctly_oc_repy_form varchar2(3) -- 最近一次还款形式:ed01bd02
    ,rctly_oc_aptrpy_dt date -- 最近一次约定还款日期:ed01br05
    ,rctly_oc_repy_tamt number(38,0) -- 最近一次应还总额:ed01bj03
    ,cur_odue_tamt number(38,0) -- 当前逾期总额(逾期总额):ed01bj04
    ,cur_odue_pnp number(38,0) -- 当前逾期本金(逾期本金):ed01bj05
    ,dbtcr_acc_odue_monum number(22) -- 借贷账户逾期月数(逾期月数):ed01bs02
    ,srpls_repy_monum number(22) -- 剩余还款月数:ed01bs03
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
grant select on ${iol_schema}.cqss_e_r_dbtcraccrepyprfmninf to ${iml_schema};
grant select on ${iol_schema}.cqss_e_r_dbtcraccrepyprfmninf to ${icl_schema};
grant select on ${iol_schema}.cqss_e_r_dbtcraccrepyprfmninf to ${idl_schema};
grant select on ${iol_schema}.cqss_e_r_dbtcraccrepyprfmninf to ${iel_schema};

-- comment
comment on table ${iol_schema}.cqss_e_r_dbtcraccrepyprfmninf is '借贷账户还款表现信息';
comment on column ${iol_schema}.cqss_e_r_dbtcraccrepyprfmninf.id is '代码主键';
comment on column ${iol_schema}.cqss_e_r_dbtcraccrepyprfmninf.msgidno is '报文标识号';
comment on column ${iol_schema}.cqss_e_r_dbtcraccrepyprfmninf.multi_tenancy_id is '多实体标识';
comment on column ${iol_schema}.cqss_e_r_dbtcraccrepyprfmninf.cr_supr_rcrd_id is '征信上级记录编号(上级序号)';
comment on column ${iol_schema}.cqss_e_r_dbtcraccrepyprfmninf.infrpt_dt is '信息报告日期:ed01br01';
comment on column ${iol_schema}.cqss_e_r_dbtcraccrepyprfmninf.bal is '余额:ed01bj01';
comment on column ${iol_schema}.cqss_e_r_dbtcraccrepyprfmninf.bal_chg_dt is '余额变化日期:ed01br02';
comment on column ${iol_schema}.cqss_e_r_dbtcraccrepyprfmninf.pbc_lv5cl_cd is '人行征信五级分类(五级分类):ed01bd01';
comment on column ${iol_schema}.cqss_e_r_dbtcraccrepyprfmninf.lv5cl_afm_dt is '五级分类认定日期:ed01br03';
comment on column ${iol_schema}.cqss_e_r_dbtcraccrepyprfmninf.rctlyocact_repydy_prd is '最近一次实际还款日期:ed01br04';
comment on column ${iol_schema}.cqss_e_r_dbtcraccrepyprfmninf.rctlyoc_act_repy_tamt is '最近一次实际还款总额:ed01bj02';
comment on column ${iol_schema}.cqss_e_r_dbtcraccrepyprfmninf.rctly_oc_repy_form is '最近一次还款形式:ed01bd02';
comment on column ${iol_schema}.cqss_e_r_dbtcraccrepyprfmninf.rctly_oc_aptrpy_dt is '最近一次约定还款日期:ed01br05';
comment on column ${iol_schema}.cqss_e_r_dbtcraccrepyprfmninf.rctly_oc_repy_tamt is '最近一次应还总额:ed01bj03';
comment on column ${iol_schema}.cqss_e_r_dbtcraccrepyprfmninf.cur_odue_tamt is '当前逾期总额(逾期总额):ed01bj04';
comment on column ${iol_schema}.cqss_e_r_dbtcraccrepyprfmninf.cur_odue_pnp is '当前逾期本金(逾期本金):ed01bj05';
comment on column ${iol_schema}.cqss_e_r_dbtcraccrepyprfmninf.dbtcr_acc_odue_monum is '借贷账户逾期月数(逾期月数):ed01bs02';
comment on column ${iol_schema}.cqss_e_r_dbtcraccrepyprfmninf.srpls_repy_monum is '剩余还款月数:ed01bs03';
comment on column ${iol_schema}.cqss_e_r_dbtcraccrepyprfmninf.crt_dt_tm is '创建日期时间';
comment on column ${iol_schema}.cqss_e_r_dbtcraccrepyprfmninf.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.cqss_e_r_dbtcraccrepyprfmninf.etl_timestamp is 'ETL处理时间戳';
