/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol nfss_tbshareext
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.nfss_tbshareext
whenever sqlerror continue none;
drop table ${iol_schema}.nfss_tbshareext purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.nfss_tbshareext(
    in_client_no varchar2(30) -- 内部客户编号
    ,bank_acc varchar2(64) -- 银行帐号
    ,bank_no varchar2(32) -- 银行编号
    ,client_no varchar2(36) -- 客户编号
    ,ta_code varchar2(18) -- ta代码
    ,prd_code varchar2(32) -- 产品代码
    ,beg_date number(22,0) -- 期初日期
    ,beg_nav number(18,8) -- 期初净值
    ,end_date number(22,0) -- 期末日期
    ,end_nav number(18,8) -- 期末净值
    ,tot_vol number(19,3) -- 当前总份额
    ,allot_amt number(18,2) -- 认购金额
    ,allot_cfm_amt number(18,2) -- 认购确认金额
    ,sub_amt number(18,2) -- 申购金额
    ,auto_sub_amt number(18,2) -- 定投金额
    ,conv_in_amt number(18,2) -- 转换入金额
    ,trust_in_amt number(18,2) -- 转托管入金额
    ,assign_in_amt number(18,2) -- 非交易过户入金额
    ,force_add_amt number(18,2) -- 份额强增折算金额
    ,red_amt number(18,2) -- 赎回金额
    ,force_red_amt number(18,2) -- 强制赎回金额
    ,conv_out_amt number(18,2) -- 转换出金额
    ,trust_out_amt number(18,2) -- 转托管出金额
    ,assign_out_amt number(18,2) -- 非交易过户出金额
    ,div_vol_amt number(18,2) -- 分红份额折算金额
    ,div_vol number(19,3) -- 分红份额
    ,div_amt number(18,2) -- 分红金额
    ,fund_end_amt number(18,2) -- 基金清盘及终止金额
    ,force_sub_amt number(18,2) -- 份额强减折算金额
    ,income_rate number(9,8) -- 投资收益率
    ,total_cost number(18,2) -- 累积投入资金
    ,total_income number(18,2) -- 累积投资收益(元)
    ,avg_price number(22,8) -- 平均买入价格
    ,amt1 number(22,6) -- 备用金额1
    ,amt2 number(22,6) -- 备用金额2
    ,amt3 number(22,6) -- 备用金额3
    ,reserve1 varchar2(375) -- 备注1
    ,reserve2 varchar2(375) -- 备注2
    ,reserve3 varchar2(375) -- 备注3
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
grant select on ${iol_schema}.nfss_tbshareext to ${iml_schema};
grant select on ${iol_schema}.nfss_tbshareext to ${icl_schema};
grant select on ${iol_schema}.nfss_tbshareext to ${idl_schema};
grant select on ${iol_schema}.nfss_tbshareext to ${iel_schema};

-- comment
comment on table ${iol_schema}.nfss_tbshareext is '浮动盈亏表(视图)';
comment on column ${iol_schema}.nfss_tbshareext.in_client_no is '内部客户编号';
comment on column ${iol_schema}.nfss_tbshareext.bank_acc is '银行帐号';
comment on column ${iol_schema}.nfss_tbshareext.bank_no is '银行编号';
comment on column ${iol_schema}.nfss_tbshareext.client_no is '客户编号';
comment on column ${iol_schema}.nfss_tbshareext.ta_code is 'ta代码';
comment on column ${iol_schema}.nfss_tbshareext.prd_code is '产品代码';
comment on column ${iol_schema}.nfss_tbshareext.beg_date is '期初日期';
comment on column ${iol_schema}.nfss_tbshareext.beg_nav is '期初净值';
comment on column ${iol_schema}.nfss_tbshareext.end_date is '期末日期';
comment on column ${iol_schema}.nfss_tbshareext.end_nav is '期末净值';
comment on column ${iol_schema}.nfss_tbshareext.tot_vol is '当前总份额';
comment on column ${iol_schema}.nfss_tbshareext.allot_amt is '认购金额';
comment on column ${iol_schema}.nfss_tbshareext.allot_cfm_amt is '认购确认金额';
comment on column ${iol_schema}.nfss_tbshareext.sub_amt is '申购金额';
comment on column ${iol_schema}.nfss_tbshareext.auto_sub_amt is '定投金额';
comment on column ${iol_schema}.nfss_tbshareext.conv_in_amt is '转换入金额';
comment on column ${iol_schema}.nfss_tbshareext.trust_in_amt is '转托管入金额';
comment on column ${iol_schema}.nfss_tbshareext.assign_in_amt is '非交易过户入金额';
comment on column ${iol_schema}.nfss_tbshareext.force_add_amt is '份额强增折算金额';
comment on column ${iol_schema}.nfss_tbshareext.red_amt is '赎回金额';
comment on column ${iol_schema}.nfss_tbshareext.force_red_amt is '强制赎回金额';
comment on column ${iol_schema}.nfss_tbshareext.conv_out_amt is '转换出金额';
comment on column ${iol_schema}.nfss_tbshareext.trust_out_amt is '转托管出金额';
comment on column ${iol_schema}.nfss_tbshareext.assign_out_amt is '非交易过户出金额';
comment on column ${iol_schema}.nfss_tbshareext.div_vol_amt is '分红份额折算金额';
comment on column ${iol_schema}.nfss_tbshareext.div_vol is '分红份额';
comment on column ${iol_schema}.nfss_tbshareext.div_amt is '分红金额';
comment on column ${iol_schema}.nfss_tbshareext.fund_end_amt is '基金清盘及终止金额';
comment on column ${iol_schema}.nfss_tbshareext.force_sub_amt is '份额强减折算金额';
comment on column ${iol_schema}.nfss_tbshareext.income_rate is '投资收益率';
comment on column ${iol_schema}.nfss_tbshareext.total_cost is '累积投入资金';
comment on column ${iol_schema}.nfss_tbshareext.total_income is '累积投资收益(元)';
comment on column ${iol_schema}.nfss_tbshareext.avg_price is '平均买入价格';
comment on column ${iol_schema}.nfss_tbshareext.amt1 is '备用金额1';
comment on column ${iol_schema}.nfss_tbshareext.amt2 is '备用金额2';
comment on column ${iol_schema}.nfss_tbshareext.amt3 is '备用金额3';
comment on column ${iol_schema}.nfss_tbshareext.reserve1 is '备注1';
comment on column ${iol_schema}.nfss_tbshareext.reserve2 is '备注2';
comment on column ${iol_schema}.nfss_tbshareext.reserve3 is '备注3';
comment on column ${iol_schema}.nfss_tbshareext.start_dt is '开始时间';
comment on column ${iol_schema}.nfss_tbshareext.end_dt is '结束时间';
comment on column ${iol_schema}.nfss_tbshareext.id_mark is '增删标志';
comment on column ${iol_schema}.nfss_tbshareext.etl_timestamp is 'ETL处理时间戳';
