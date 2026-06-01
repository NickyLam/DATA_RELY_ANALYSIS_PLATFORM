/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol mrms_tbl_mcht_settle_inf
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.mrms_tbl_mcht_settle_inf
whenever sqlerror continue none;
drop table ${iol_schema}.mrms_tbl_mcht_settle_inf purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.mrms_tbl_mcht_settle_inf(
    mcht_no varchar2(23) -- 商户号
    ,settle_type varchar2(2) -- 商户结算方式
    ,rate_flag varchar2(2) -- 手续费结算类型
    ,settle_chn varchar2(2) -- 商户结算渠道
    ,bat_time varchar2(6) -- 每日批上送时间
    ,auto_stl_flg varchar2(2) -- 自动清算标志
    ,part_num varchar2(30) -- 商户分期期数
    ,fee_type varchar2(2) -- 01-特殊扣率-固定费
    ,fee_fixed varchar2(23) -- 固定手续费
    ,fee_max_amt varchar2(23) -- 手续费上限
    ,fee_min_amt varchar2(23) -- 手续费下限
    ,fee_rate varchar2(12) -- 手续费百分百率
    ,fee_div_1 varchar2(90) -- 分段一
    ,fee_div_2 varchar2(90) -- 分段二
    ,fee_div_3 varchar2(90) -- 分段三
    ,settle_mode varchar2(2) -- 商户本金清算模式
    ,fee_cycle varchar2(3) -- 手续费清算周期
    ,settle_rpt varchar2(2) -- 商户入账凭单模式
    ,settle_bank_no varchar2(30) -- 商户结算帐户开户行
    ,settle_bank_nm varchar2(120) -- 商户结算帐户开户行名称
    ,settle_acct_nm varchar2(120) -- 商户结算帐户户名
    ,settle_acct varchar2(60) -- 商户结算帐户号
    ,fee_acct_nm varchar2(120) -- 手续费结算帐户名
    ,fee_acct varchar2(60) -- 手续费结算帐户号
    ,group_flag varchar2(2) -- 是否清算到集团商户
    ,open_stlno varchar2(30) -- 商户开户行号
    ,change_stlno varchar2(30) -- 客户号
    ,spe_settle_tp varchar2(18) -- 特殊计费类型
    ,spe_settle_lv varchar2(72) -- 特殊计费档次
    ,spe_settle_ds varchar2(383) -- 特殊计费描述
    ,fee_back_flg varchar2(2) -- 退货返还手续费标志
    ,reserved varchar2(90) -- 保留
    ,rec_upd_ts varchar2(21) -- 记录更新时间
    ,rec_crt_ts varchar2(21) -- 记录创建时间
    ,settle_bank_no2 varchar2(17) -- 商户结算账户开户行号2
    ,settle_bank_nm2 varchar2(120) -- 商户结算账户开户行名2
    ,settle_acct_nm2 varchar2(45) -- 商户结算账户户名2
    ,settle_acct2 varchar2(60) -- 商户结算账户号2
    ,settle_bank_no3 varchar2(17) -- 商户结算账户开户行号3
    ,settle_bank_nm3 varchar2(120) -- 商户结算账户开户行名3
    ,settle_acct_nm3 varchar2(45) -- 商户结算账户户名3
    ,settle_acct3 varchar2(60) -- 商户结算账户号3
    ,paymnt_stl_proj_nm varchar2(60) -- 缴费项目名称
    ,paymnt_stl_proj_no varchar2(30) -- 缴费项目编号
    ,acct_type varchar2(2) -- 账户类型
    ,open_stlno3 varchar2(30) -- 商户开户行号
    ,change_stlno3 varchar2(30) -- 客户号
    ,open_stlno2 varchar2(30) -- 商户开户行号
    ,change_stlno2 varchar2(30) -- 客户号
    ,misc_1 varchar2(384) -- 保留字段1
    ,misc_2 varchar2(384) -- 保留字段2
    ,misc_3 varchar2(384) -- 保留字段3
    ,misc_flag varchar2(45) -- 保留标识1
    ,acct_flag varchar2(2) -- 
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
grant select on ${iol_schema}.mrms_tbl_mcht_settle_inf to ${iml_schema};
grant select on ${iol_schema}.mrms_tbl_mcht_settle_inf to ${icl_schema};
grant select on ${iol_schema}.mrms_tbl_mcht_settle_inf to ${idl_schema};
grant select on ${iol_schema}.mrms_tbl_mcht_settle_inf to ${iel_schema};

-- comment
comment on table ${iol_schema}.mrms_tbl_mcht_settle_inf is '商户清算信息表';
comment on column ${iol_schema}.mrms_tbl_mcht_settle_inf.mcht_no is '商户号';
comment on column ${iol_schema}.mrms_tbl_mcht_settle_inf.settle_type is '商户结算方式';
comment on column ${iol_schema}.mrms_tbl_mcht_settle_inf.rate_flag is '手续费结算类型';
comment on column ${iol_schema}.mrms_tbl_mcht_settle_inf.settle_chn is '商户结算渠道';
comment on column ${iol_schema}.mrms_tbl_mcht_settle_inf.bat_time is '每日批上送时间';
comment on column ${iol_schema}.mrms_tbl_mcht_settle_inf.auto_stl_flg is '自动清算标志';
comment on column ${iol_schema}.mrms_tbl_mcht_settle_inf.part_num is '商户分期期数';
comment on column ${iol_schema}.mrms_tbl_mcht_settle_inf.fee_type is '01-特殊扣率-固定费';
comment on column ${iol_schema}.mrms_tbl_mcht_settle_inf.fee_fixed is '固定手续费';
comment on column ${iol_schema}.mrms_tbl_mcht_settle_inf.fee_max_amt is '手续费上限';
comment on column ${iol_schema}.mrms_tbl_mcht_settle_inf.fee_min_amt is '手续费下限';
comment on column ${iol_schema}.mrms_tbl_mcht_settle_inf.fee_rate is '手续费百分百率';
comment on column ${iol_schema}.mrms_tbl_mcht_settle_inf.fee_div_1 is '分段一';
comment on column ${iol_schema}.mrms_tbl_mcht_settle_inf.fee_div_2 is '分段二';
comment on column ${iol_schema}.mrms_tbl_mcht_settle_inf.fee_div_3 is '分段三';
comment on column ${iol_schema}.mrms_tbl_mcht_settle_inf.settle_mode is '商户本金清算模式';
comment on column ${iol_schema}.mrms_tbl_mcht_settle_inf.fee_cycle is '手续费清算周期';
comment on column ${iol_schema}.mrms_tbl_mcht_settle_inf.settle_rpt is '商户入账凭单模式';
comment on column ${iol_schema}.mrms_tbl_mcht_settle_inf.settle_bank_no is '商户结算帐户开户行';
comment on column ${iol_schema}.mrms_tbl_mcht_settle_inf.settle_bank_nm is '商户结算帐户开户行名称';
comment on column ${iol_schema}.mrms_tbl_mcht_settle_inf.settle_acct_nm is '商户结算帐户户名';
comment on column ${iol_schema}.mrms_tbl_mcht_settle_inf.settle_acct is '商户结算帐户号';
comment on column ${iol_schema}.mrms_tbl_mcht_settle_inf.fee_acct_nm is '手续费结算帐户名';
comment on column ${iol_schema}.mrms_tbl_mcht_settle_inf.fee_acct is '手续费结算帐户号';
comment on column ${iol_schema}.mrms_tbl_mcht_settle_inf.group_flag is '是否清算到集团商户';
comment on column ${iol_schema}.mrms_tbl_mcht_settle_inf.open_stlno is '商户开户行号';
comment on column ${iol_schema}.mrms_tbl_mcht_settle_inf.change_stlno is '客户号';
comment on column ${iol_schema}.mrms_tbl_mcht_settle_inf.spe_settle_tp is '特殊计费类型';
comment on column ${iol_schema}.mrms_tbl_mcht_settle_inf.spe_settle_lv is '特殊计费档次';
comment on column ${iol_schema}.mrms_tbl_mcht_settle_inf.spe_settle_ds is '特殊计费描述';
comment on column ${iol_schema}.mrms_tbl_mcht_settle_inf.fee_back_flg is '退货返还手续费标志';
comment on column ${iol_schema}.mrms_tbl_mcht_settle_inf.reserved is '保留';
comment on column ${iol_schema}.mrms_tbl_mcht_settle_inf.rec_upd_ts is '记录更新时间';
comment on column ${iol_schema}.mrms_tbl_mcht_settle_inf.rec_crt_ts is '记录创建时间';
comment on column ${iol_schema}.mrms_tbl_mcht_settle_inf.settle_bank_no2 is '商户结算账户开户行号2';
comment on column ${iol_schema}.mrms_tbl_mcht_settle_inf.settle_bank_nm2 is '商户结算账户开户行名2';
comment on column ${iol_schema}.mrms_tbl_mcht_settle_inf.settle_acct_nm2 is '商户结算账户户名2';
comment on column ${iol_schema}.mrms_tbl_mcht_settle_inf.settle_acct2 is '商户结算账户号2';
comment on column ${iol_schema}.mrms_tbl_mcht_settle_inf.settle_bank_no3 is '商户结算账户开户行号3';
comment on column ${iol_schema}.mrms_tbl_mcht_settle_inf.settle_bank_nm3 is '商户结算账户开户行名3';
comment on column ${iol_schema}.mrms_tbl_mcht_settle_inf.settle_acct_nm3 is '商户结算账户户名3';
comment on column ${iol_schema}.mrms_tbl_mcht_settle_inf.settle_acct3 is '商户结算账户号3';
comment on column ${iol_schema}.mrms_tbl_mcht_settle_inf.paymnt_stl_proj_nm is '缴费项目名称';
comment on column ${iol_schema}.mrms_tbl_mcht_settle_inf.paymnt_stl_proj_no is '缴费项目编号';
comment on column ${iol_schema}.mrms_tbl_mcht_settle_inf.acct_type is '账户类型';
comment on column ${iol_schema}.mrms_tbl_mcht_settle_inf.open_stlno3 is '商户开户行号';
comment on column ${iol_schema}.mrms_tbl_mcht_settle_inf.change_stlno3 is '客户号';
comment on column ${iol_schema}.mrms_tbl_mcht_settle_inf.open_stlno2 is '商户开户行号';
comment on column ${iol_schema}.mrms_tbl_mcht_settle_inf.change_stlno2 is '客户号';
comment on column ${iol_schema}.mrms_tbl_mcht_settle_inf.misc_1 is '保留字段1';
comment on column ${iol_schema}.mrms_tbl_mcht_settle_inf.misc_2 is '保留字段2';
comment on column ${iol_schema}.mrms_tbl_mcht_settle_inf.misc_3 is '保留字段3';
comment on column ${iol_schema}.mrms_tbl_mcht_settle_inf.misc_flag is '保留标识1';
comment on column ${iol_schema}.mrms_tbl_mcht_settle_inf.acct_flag is '';
comment on column ${iol_schema}.mrms_tbl_mcht_settle_inf.start_dt is '开始时间';
comment on column ${iol_schema}.mrms_tbl_mcht_settle_inf.end_dt is '结束时间';
comment on column ${iol_schema}.mrms_tbl_mcht_settle_inf.id_mark is '增删标志';
comment on column ${iol_schema}.mrms_tbl_mcht_settle_inf.etl_timestamp is 'ETL处理时间戳';
