/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol cqss_i_r_creditsummary
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.cqss_i_r_creditsummary
whenever sqlerror continue none;
drop table ${iol_schema}.cqss_i_r_creditsummary purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.cqss_i_r_creditsummary(
    id varchar2(96) -- 代码主键
    ,msgidno varchar2(53) -- 报文标识号
    ,pbc_digt_iptn number(22) -- 人行数字解读
    ,rel_lo number(22) -- 相对位置
    ,scor_cmnt_num number(22) -- 分数说明条数
    ,crln_acc_tot number(22) -- 信贷账户数合计:pc02as01
    ,crbn_tp_num number(22) -- 信贷业务类型数量:pc02as02
    ,be_rec_acc_tot number(22) -- 被追偿账户数合计:pc02bs01
    ,be_rec_bal_tot number(38,0) -- 被追偿余额合计:pc02bj01
    ,be_rec_btp_num number(22) -- 被追偿业务类型数量:pc02bs02
    ,stgdbt_acc number(22) -- 呆账账户数:pc02cs01
    ,stgdbt_bal number(38,0) -- 呆账余额:pc02cj01
    ,odue_od_btp_num number(22) -- 逾期透支业务类型数量:pc02ds01
    ,rel_repy_rspl_num number(22) -- 相关还款责任个数:pc02ks01
    ,af_py_btp_num number(22) -- 后付费业务类型数量:pc030s01
    ,pblc_inf_tp_num number(22) -- 公共信息类型数量:pc040s01
    ,lt_enqr_dt date -- 上一次查询日期:pc05ar01
    ,lt_enqr_inst_tp varchar2(3) -- 上一次查询机构类型:pc05ad01
    ,lt_enqr_inst_cd varchar2(96) -- 上一次查询机构代码:pc05ai01
    ,lt_enqr_rsn varchar2(9) -- 上一次查询原因:pc05aq01
    ,lnaprvrcy1emieinstnum number(22) -- 贷款审批最近1个月内的查询机构数:pc05bs01
    ,ccarcy1emienqrinstnum number(22) -- 信用卡审批最近1个月内的查询机构数:pc05bs02
    ,lnaprvrcly1emienqrcnt number(22) -- 贷款审批最近1个月内的查询次数:pc05bs03
    ,ccarcy1eminnrsenqrcnt number(22) -- 信用卡审批最近1个月内的查询次数:pc05bs04
    ,myslfenqrr1emienqrcnt number(22) -- 本人查询最近1个月内的查询次数:pc05bs05
    ,pstloanmgtr2yienqrcnt number(22) -- 贷后管理最近2年内的查询次数:pc05bs06
    ,wrntquaexmr2yienqrcnt number(22) -- 担保资格审查最近2年内的查询次数:pc05bs07
    ,apntmrchrner2yienrcnt number(22) -- 特约商户实名审查最近2年内的查询次数:pc05bs08
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
grant select on ${iol_schema}.cqss_i_r_creditsummary to ${iml_schema};
grant select on ${iol_schema}.cqss_i_r_creditsummary to ${icl_schema};
grant select on ${iol_schema}.cqss_i_r_creditsummary to ${idl_schema};
grant select on ${iol_schema}.cqss_i_r_creditsummary to ${iel_schema};

-- comment
comment on table ${iol_schema}.cqss_i_r_creditsummary is '二代信息概要';
comment on column ${iol_schema}.cqss_i_r_creditsummary.id is '代码主键';
comment on column ${iol_schema}.cqss_i_r_creditsummary.msgidno is '报文标识号';
comment on column ${iol_schema}.cqss_i_r_creditsummary.pbc_digt_iptn is '人行数字解读';
comment on column ${iol_schema}.cqss_i_r_creditsummary.rel_lo is '相对位置';
comment on column ${iol_schema}.cqss_i_r_creditsummary.scor_cmnt_num is '分数说明条数';
comment on column ${iol_schema}.cqss_i_r_creditsummary.crln_acc_tot is '信贷账户数合计:pc02as01';
comment on column ${iol_schema}.cqss_i_r_creditsummary.crbn_tp_num is '信贷业务类型数量:pc02as02';
comment on column ${iol_schema}.cqss_i_r_creditsummary.be_rec_acc_tot is '被追偿账户数合计:pc02bs01';
comment on column ${iol_schema}.cqss_i_r_creditsummary.be_rec_bal_tot is '被追偿余额合计:pc02bj01';
comment on column ${iol_schema}.cqss_i_r_creditsummary.be_rec_btp_num is '被追偿业务类型数量:pc02bs02';
comment on column ${iol_schema}.cqss_i_r_creditsummary.stgdbt_acc is '呆账账户数:pc02cs01';
comment on column ${iol_schema}.cqss_i_r_creditsummary.stgdbt_bal is '呆账余额:pc02cj01';
comment on column ${iol_schema}.cqss_i_r_creditsummary.odue_od_btp_num is '逾期透支业务类型数量:pc02ds01';
comment on column ${iol_schema}.cqss_i_r_creditsummary.rel_repy_rspl_num is '相关还款责任个数:pc02ks01';
comment on column ${iol_schema}.cqss_i_r_creditsummary.af_py_btp_num is '后付费业务类型数量:pc030s01';
comment on column ${iol_schema}.cqss_i_r_creditsummary.pblc_inf_tp_num is '公共信息类型数量:pc040s01';
comment on column ${iol_schema}.cqss_i_r_creditsummary.lt_enqr_dt is '上一次查询日期:pc05ar01';
comment on column ${iol_schema}.cqss_i_r_creditsummary.lt_enqr_inst_tp is '上一次查询机构类型:pc05ad01';
comment on column ${iol_schema}.cqss_i_r_creditsummary.lt_enqr_inst_cd is '上一次查询机构代码:pc05ai01';
comment on column ${iol_schema}.cqss_i_r_creditsummary.lt_enqr_rsn is '上一次查询原因:pc05aq01';
comment on column ${iol_schema}.cqss_i_r_creditsummary.lnaprvrcy1emieinstnum is '贷款审批最近1个月内的查询机构数:pc05bs01';
comment on column ${iol_schema}.cqss_i_r_creditsummary.ccarcy1emienqrinstnum is '信用卡审批最近1个月内的查询机构数:pc05bs02';
comment on column ${iol_schema}.cqss_i_r_creditsummary.lnaprvrcly1emienqrcnt is '贷款审批最近1个月内的查询次数:pc05bs03';
comment on column ${iol_schema}.cqss_i_r_creditsummary.ccarcy1eminnrsenqrcnt is '信用卡审批最近1个月内的查询次数:pc05bs04';
comment on column ${iol_schema}.cqss_i_r_creditsummary.myslfenqrr1emienqrcnt is '本人查询最近1个月内的查询次数:pc05bs05';
comment on column ${iol_schema}.cqss_i_r_creditsummary.pstloanmgtr2yienqrcnt is '贷后管理最近2年内的查询次数:pc05bs06';
comment on column ${iol_schema}.cqss_i_r_creditsummary.wrntquaexmr2yienqrcnt is '担保资格审查最近2年内的查询次数:pc05bs07';
comment on column ${iol_schema}.cqss_i_r_creditsummary.apntmrchrner2yienrcnt is '特约商户实名审查最近2年内的查询次数:pc05bs08';
comment on column ${iol_schema}.cqss_i_r_creditsummary.multi_tenancy_id is '多实体标识';
comment on column ${iol_schema}.cqss_i_r_creditsummary.crt_dt_tm is '创建日期时间';
comment on column ${iol_schema}.cqss_i_r_creditsummary.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.cqss_i_r_creditsummary.etl_timestamp is 'ETL处理时间戳';
