/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol cqss_i_r_latestmonthlyinfo
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.cqss_i_r_latestmonthlyinfo
whenever sqlerror continue none;
drop table ${iol_schema}.cqss_i_r_latestmonthlyinfo purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.cqss_i_r_latestmonthlyinfo(
    id varchar2(96) -- 代码主键
    ,cr_supr_rcrd_id varchar2(96) -- 征信上级记录编号
    ,msgidno varchar2(53) -- 报文标识号
    ,mo varchar2(11) -- 月份:pd01cr01
    ,dbtcr_acc_st varchar2(9) -- 借贷账户状态:pd01cd01
    ,dbtcr_acba number(38,0) -- 借贷账户余额:pd01cj01
    ,usd_lmt number(38,0) -- 已用额度:pd01cj02
    ,notisugsbigasinstmbal number(38,0) -- 未出单的大额专项分期余额:pd01cj03
    ,pbc_lv5cl_cd varchar2(2) -- 人行五级分类代码:pd01cd02
    ,srpls_repy_prd number(38,0) -- 剩余还款期数:pd01cs01
    ,setl_repydy date -- 结算还款日:pd01cr02
    ,tm_shldrepymt_amt number(38,0) -- 本月应还款金额:pd01cj04
    ,tm_act_repy_amt number(38,0) -- 本月实际还款金额:pd01cj05
    ,rctlyocact_repydy_prd date -- 最近一次实际还款日期:pd01cr03
    ,cur_odue_prd number(22) -- 当前逾期期数:pd01cs02
    ,cur_odue_tamt number(38,0) -- 当前逾期总额:pd01cj06
    ,odue31to60dynotretpnp number(38,0) -- 逾期31至60天未归还本金:pd01cj07
    ,odue61to90dynotretpnp number(38,0) -- 逾期61至90天未归还本金:pd01cj08
    ,odue91toohednotretpnp number(38,0) -- 逾期91至180天未归还本金:pd01cj09
    ,odueohedyabv_ntpa_bal number(38,0) -- 逾期180天以上未归还本金:pd01cj10
    ,od_ohedy_abv_ntpa_bal number(38,0) -- 透支180天以上未还余额:pd01cj11
    ,rctly6etrsmoavgus_lmt number(38,0) -- 最近6个月平均使用额度:pd01cj12
    ,rctly6etrsmoavgod_bal number(38,0) -- 最近6个月平均透支余额:pd01cj13
    ,max_us_lmt number(38,0) -- 最大使用额度:pd01cj14
    ,max_od_bal number(38,0) -- 最大透支余额:pd01cj15
    ,rpt_dt date -- 信息报告日期:pd01cr04
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
grant select on ${iol_schema}.cqss_i_r_latestmonthlyinfo to ${iml_schema};
grant select on ${iol_schema}.cqss_i_r_latestmonthlyinfo to ${icl_schema};
grant select on ${iol_schema}.cqss_i_r_latestmonthlyinfo to ${idl_schema};
grant select on ${iol_schema}.cqss_i_r_latestmonthlyinfo to ${iel_schema};

-- comment
comment on table ${iol_schema}.cqss_i_r_latestmonthlyinfo is '二代借贷账户最近一次月度表现信息';
comment on column ${iol_schema}.cqss_i_r_latestmonthlyinfo.id is '代码主键';
comment on column ${iol_schema}.cqss_i_r_latestmonthlyinfo.cr_supr_rcrd_id is '征信上级记录编号';
comment on column ${iol_schema}.cqss_i_r_latestmonthlyinfo.msgidno is '报文标识号';
comment on column ${iol_schema}.cqss_i_r_latestmonthlyinfo.mo is '月份:pd01cr01';
comment on column ${iol_schema}.cqss_i_r_latestmonthlyinfo.dbtcr_acc_st is '借贷账户状态:pd01cd01';
comment on column ${iol_schema}.cqss_i_r_latestmonthlyinfo.dbtcr_acba is '借贷账户余额:pd01cj01';
comment on column ${iol_schema}.cqss_i_r_latestmonthlyinfo.usd_lmt is '已用额度:pd01cj02';
comment on column ${iol_schema}.cqss_i_r_latestmonthlyinfo.notisugsbigasinstmbal is '未出单的大额专项分期余额:pd01cj03';
comment on column ${iol_schema}.cqss_i_r_latestmonthlyinfo.pbc_lv5cl_cd is '人行五级分类代码:pd01cd02';
comment on column ${iol_schema}.cqss_i_r_latestmonthlyinfo.srpls_repy_prd is '剩余还款期数:pd01cs01';
comment on column ${iol_schema}.cqss_i_r_latestmonthlyinfo.setl_repydy is '结算还款日:pd01cr02';
comment on column ${iol_schema}.cqss_i_r_latestmonthlyinfo.tm_shldrepymt_amt is '本月应还款金额:pd01cj04';
comment on column ${iol_schema}.cqss_i_r_latestmonthlyinfo.tm_act_repy_amt is '本月实际还款金额:pd01cj05';
comment on column ${iol_schema}.cqss_i_r_latestmonthlyinfo.rctlyocact_repydy_prd is '最近一次实际还款日期:pd01cr03';
comment on column ${iol_schema}.cqss_i_r_latestmonthlyinfo.cur_odue_prd is '当前逾期期数:pd01cs02';
comment on column ${iol_schema}.cqss_i_r_latestmonthlyinfo.cur_odue_tamt is '当前逾期总额:pd01cj06';
comment on column ${iol_schema}.cqss_i_r_latestmonthlyinfo.odue31to60dynotretpnp is '逾期31至60天未归还本金:pd01cj07';
comment on column ${iol_schema}.cqss_i_r_latestmonthlyinfo.odue61to90dynotretpnp is '逾期61至90天未归还本金:pd01cj08';
comment on column ${iol_schema}.cqss_i_r_latestmonthlyinfo.odue91toohednotretpnp is '逾期91至180天未归还本金:pd01cj09';
comment on column ${iol_schema}.cqss_i_r_latestmonthlyinfo.odueohedyabv_ntpa_bal is '逾期180天以上未归还本金:pd01cj10';
comment on column ${iol_schema}.cqss_i_r_latestmonthlyinfo.od_ohedy_abv_ntpa_bal is '透支180天以上未还余额:pd01cj11';
comment on column ${iol_schema}.cqss_i_r_latestmonthlyinfo.rctly6etrsmoavgus_lmt is '最近6个月平均使用额度:pd01cj12';
comment on column ${iol_schema}.cqss_i_r_latestmonthlyinfo.rctly6etrsmoavgod_bal is '最近6个月平均透支余额:pd01cj13';
comment on column ${iol_schema}.cqss_i_r_latestmonthlyinfo.max_us_lmt is '最大使用额度:pd01cj14';
comment on column ${iol_schema}.cqss_i_r_latestmonthlyinfo.max_od_bal is '最大透支余额:pd01cj15';
comment on column ${iol_schema}.cqss_i_r_latestmonthlyinfo.rpt_dt is '信息报告日期:pd01cr04';
comment on column ${iol_schema}.cqss_i_r_latestmonthlyinfo.multi_tenancy_id is '多实体标识';
comment on column ${iol_schema}.cqss_i_r_latestmonthlyinfo.crt_dt_tm is '创建日期时间';
comment on column ${iol_schema}.cqss_i_r_latestmonthlyinfo.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.cqss_i_r_latestmonthlyinfo.etl_timestamp is 'ETL处理时间戳';
