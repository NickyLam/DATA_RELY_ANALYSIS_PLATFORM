/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol nfss_tbproduct
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.nfss_tbproduct
whenever sqlerror continue none;
drop table ${iol_schema}.nfss_tbproduct purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.nfss_tbproduct(
    prd_code varchar2(32) -- 产品代码
    ,model_flag varchar2(2) -- 产品归属类别
    ,model_comment varchar2(512) -- 模板说明
    ,prd_type varchar2(2) -- 产品类别
    ,ta_code varchar2(18) -- ta代码
    ,prd_name varchar2(375) -- 产品名称
    ,prd_name2 varchar2(375) -- 产品别名
    ,vol_digit number(22,0) -- 产品份额小数位数
    ,amt_digit number(22,0) -- 产品金额小数位数
    ,nav_digit number(22,0) -- 产品净值小数位数
    ,nav number(18,8) -- 产品净值
    ,nav_date number(22,0) -- 净值日期
    ,nav_days number(22,0) -- 净值天数
    ,face_value number(18,8) -- 产品面值
    ,iss_price number(22,8) -- 发行价格
    ,asso_code varchar2(30) -- 关联代码
    ,prd_sponsor varchar2(18) -- 产品发起人
    ,prd_trustee varchar2(40) -- 产品托管人
    ,prd_manager varchar2(18) -- 产品管理人
    ,dep_id varchar2(256) -- 产品主办部门
    ,branch_no varchar2(24) -- 产品主办机构
    ,ipo_start_date number(22,0) -- 募集开始日期
    ,ipo_end_date number(22,0) -- 募集结束日期
    ,estab_date number(22,0) -- 产品成立日期
    ,income_date number(22,0) -- 产品起息日期
    ,end_date number(22,0) -- 产品结束日期
    ,interest_end_date number(22,0) -- 利息截止日#
    ,income_end_date number(22,0) -- 收益到期日#
    ,issue_fail_date number(22,0) -- 募集失败日期#
    ,alimit_end_date number(22,0) -- 募集后封闭到期日#
    ,real_estab_date number(22,0) -- 实际成立日期#
    ,prd_min_bala number(18,2) -- 产品最低募集金额
    ,prd_max_bala number(18,2) -- 产品最高募集金额
    ,prd_min_shares number(18,3) -- 产品最低募集份额#
    ,prd_max_shares number(18,3) -- 产品最高募集份额#
    ,prd_issue_real_bala number(18,2) -- 产品实际募集金额#
    ,curr_scale number(18,2) -- 当前规模
    ,div_modes varchar2(12) -- 允许的分红方式
    ,div_mode varchar2(2) -- 默认分红方式
    ,inst_flag varchar2(2) -- 销售区域是否控制标志
    ,limit_flag varchar2(2) -- 额度控制标志
    ,liqu_mode varchar2(2) -- 募集期帐务模式
    ,liqu_mode2 varchar2(2) -- 开放期帐务模式
    ,channels varchar2(75) -- 允许渠道组
    ,client_groups varchar2(30) -- 允许客户组
    ,temp_flag varchar2(4) -- 模板标志
    ,control_flag varchar2(512) -- 控制标志
    ,control_flag2 varchar2(375) -- bta控制标志#
    ,share_class varchar2(3) -- 前后端收费类别
    ,issue_cfm_rate number(9,8) -- 成立确认比例#
    ,sub_mode varchar2(2) -- 是否外收费
    ,sub_exp varchar2(2) -- 认购导出模式
    ,interest_way varchar2(2) -- 收益体现方式
    ,prd_attr varchar2(2) -- 产品属性
    ,risk_level number(22,0) -- 风险等级
    ,grade varchar2(2) -- 评估等级
    ,status varchar2(2) -- 产品状态
    ,conv_flag varchar2(2) -- 转换标志
    ,prd_totvol number(18,3) -- 产品当前总份额
    ,tot_nav number(23,8) -- 产品累计净值
    ,curr_type varchar2(5) -- 币种
    ,cost_curr_type varchar2(5) -- 返还本金币种
    ,income_curr_type varchar2(5) -- 收益币种
    ,cash_flag varchar2(2) -- 钞汇标志
    ,agio_type varchar2(2) -- 折扣率计算方式
    ,open_time number(22,0) -- 开市时间
    ,close_time number(22,0) -- 闭市时间
    ,paper_no number(22,0) -- 产品适合度试卷编号
    ,paper_name varchar2(375) -- 产品适合度试卷名称
    ,protocol_name varchar2(375) -- 产品协议书名称
    ,psub_unit number(24,2) -- 个人最小购买单位
    ,pfirst_amt number(18,2) -- 个人首次最低投资金额
    ,papp_amt number(18,2) -- 个人追加最低投资金额
    ,pmin_invest_amt number(18,2) -- 个人最低定投金额
    ,pmin_hold number(18,3) -- 个人最低持有份额
    ,pmin_red number(18,3) -- 个人单笔最少赎回份额
    ,pmax_red number(18,3) -- 个人单笔最大赎回份额
    ,pred_unit number(18,3) -- 个人赎回单位
    ,pmin_conv_vol number(18,3) -- 个人最低基金转换份额
    ,pmin_red_vol number(18,3) -- 个人最低定赎份额
    ,pmax_amt number(18,2) -- 个人单笔最大购买金额
    ,pmax_accu_amt number(18,2) -- 个人单户累计最大购买金额#
    ,osub_unit number(24,2) -- 机构最小购买单位
    ,ofirst_amt number(18,2) -- 机构首次最低投资金额
    ,oapp_amt number(18,2) -- 机构追加最低投资金额
    ,omin_invest_amt number(18,2) -- 机构最低定投金额
    ,omin_hold number(18,3) -- 机构最低持有份额
    ,omin_red number(18,3) -- 机构单笔最小赎回份额
    ,omax_red number(18,3) -- 机构单笔最大赎回份额
    ,ored_unit number(18,3) -- 机构赎回单位
    ,omin_conv_vol number(18,3) -- 机构最低基金转换份额
    ,omin_red_vol number(18,3) -- 机构最低定赎份额
    ,omax_amt number(18,2) -- 机构单笔最大购买金额
    ,omax_accu_amt number(18,2) -- 机构单户累计最大购买金额#
    ,tot_client number(22,0) -- 累计购买客户数
    ,ipo_time number(22,0) -- 募集开始时间
    ,order_date number(22,0) -- 预约购买开始日期
    ,order_time number(22,0) -- 预约购买开始时间
    ,book_buy_days number(22,0) -- 客户预约购买最大允许提前天数
    ,book_sell_days number(22,0) -- 客户预约赎回最大允许提前天数
    ,book_buy_date number(22,0) -- 银行指定预约购买受理日
    ,book_sell_date number(22,0) -- 银行指定预约赎回受理日
    ,dir_order_type varchar2(2) -- 定向预约模式
    ,dir_hold_day number(22,0) -- 定向预约有效天数
    ,dir_free_date number(22,0) -- 定向预约释放日期
    ,dir_start_date number(22,0) -- 定向预约开始日期
    ,dir_start_time number(22,0) -- 定向预约开始时间
    ,invest_fail_times number(22,0) -- 定投失败次数
    ,debit_account varchar2(48) -- 认申购账号
    ,crebit_account varchar2(48) -- 赎回账号
    ,red_draw_account varchar2(48) -- 实时赎回垫支帐号
    ,charge_account varchar2(48) -- 手续费分配账号
    ,manage_account varchar2(48) -- 管理费分配账号
    ,red_days number(22,0) -- 赎回资金到帐天数
    ,div_days number(22,0) -- 分红资金到帐天数
    ,refund_days number(22,0) -- 产品到期资金到帐天数
    ,fail_days number(22,0) -- 发行失败/比例退款天数
    ,open_buy_days number(22,0) -- 申购失败资金到帐延迟天数
    ,red_arr_date number(22,0) -- 赎回资金到帐日期
    ,div_arr_date number(22,0) -- 分红资金到帐日期
    ,refund_arr_date number(22,0) -- 产品到期资金到帐日期
    ,fail_arr_date number(22,0) -- 发行失败/比例退款到帐日期
    ,open_arr_date number(22,0) -- 申购失败资金到帐延迟日期
    ,large_buy_rate number(9,8) -- 超额申购比例#
    ,large_red_rate number(9,8) -- 巨额赎回比例#
    ,real_red_amt_rate number(9,8) -- 实时赎回资金比例
    ,real_red_vol_rate number(9,8) -- 当日实时赎回份额比例上限#
    ,real_red_max_vol number(18,3) -- 当日实时赎回份额上限
    ,base_days number(22,0) -- 产品计息基数#
    ,interest_days number(22,0) -- 认购利息计息基数#
    ,manage_days number(22,0) -- 管理费基础天数#
    ,red_fare_rate number(5,4) -- 赎回费归基金资产比例#
    ,conv_fare_rate number(5,4) -- 转换费归基金资产比例#
    ,manage_rate number(5,4) -- 管理费计提比例#
    ,total_bonus number(18,8) -- 累计单位分红#
    ,cash_rate varchar2(2) -- 货币式产品收益兑付频率
    ,money_date number(22,0) -- 货币产品收益兑付日期#
    ,corpus_rate number(5,4) -- 保本比例#
    ,evend_date number(22,0) -- 保本到期日#
    ,tn_confirm number(22,0) -- 所有业务清算延后天数#
    ,guest_rate number(18,8) -- 预期收益率#
    ,cycle_days number(22,0) -- 周期天数#
    ,trans_way varchar2(2) -- 交易方式
    ,int1 number(22,0) -- 备用整数1
    ,int2 number(22,0) -- 备用整数2
    ,amt1 number(22,6) -- 备用金额1
    ,amt2 number(22,6) -- 备用金额2
    ,amt3 number(22,6) -- 备用金额3
    ,reserve1 varchar2(375) -- 备注1
    ,reserve2 varchar2(375) -- 备注2
    ,reserve3 varchar2(375) -- 备注3
    ,reserve4 varchar2(375) -- 备注4
    ,reserve5 varchar2(375) -- 备注5
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
grant select on ${iol_schema}.nfss_tbproduct to ${iml_schema};
grant select on ${iol_schema}.nfss_tbproduct to ${icl_schema};
grant select on ${iol_schema}.nfss_tbproduct to ${idl_schema};
grant select on ${iol_schema}.nfss_tbproduct to ${iel_schema};

-- comment
comment on table ${iol_schema}.nfss_tbproduct is '产品信息表';
comment on column ${iol_schema}.nfss_tbproduct.prd_code is '产品代码';
comment on column ${iol_schema}.nfss_tbproduct.model_flag is '产品归属类别';
comment on column ${iol_schema}.nfss_tbproduct.model_comment is '模板说明';
comment on column ${iol_schema}.nfss_tbproduct.prd_type is '产品类别';
comment on column ${iol_schema}.nfss_tbproduct.ta_code is 'ta代码';
comment on column ${iol_schema}.nfss_tbproduct.prd_name is '产品名称';
comment on column ${iol_schema}.nfss_tbproduct.prd_name2 is '产品别名';
comment on column ${iol_schema}.nfss_tbproduct.vol_digit is '产品份额小数位数';
comment on column ${iol_schema}.nfss_tbproduct.amt_digit is '产品金额小数位数';
comment on column ${iol_schema}.nfss_tbproduct.nav_digit is '产品净值小数位数';
comment on column ${iol_schema}.nfss_tbproduct.nav is '产品净值';
comment on column ${iol_schema}.nfss_tbproduct.nav_date is '净值日期';
comment on column ${iol_schema}.nfss_tbproduct.nav_days is '净值天数';
comment on column ${iol_schema}.nfss_tbproduct.face_value is '产品面值';
comment on column ${iol_schema}.nfss_tbproduct.iss_price is '发行价格';
comment on column ${iol_schema}.nfss_tbproduct.asso_code is '关联代码';
comment on column ${iol_schema}.nfss_tbproduct.prd_sponsor is '产品发起人';
comment on column ${iol_schema}.nfss_tbproduct.prd_trustee is '产品托管人';
comment on column ${iol_schema}.nfss_tbproduct.prd_manager is '产品管理人';
comment on column ${iol_schema}.nfss_tbproduct.dep_id is '产品主办部门';
comment on column ${iol_schema}.nfss_tbproduct.branch_no is '产品主办机构';
comment on column ${iol_schema}.nfss_tbproduct.ipo_start_date is '募集开始日期';
comment on column ${iol_schema}.nfss_tbproduct.ipo_end_date is '募集结束日期';
comment on column ${iol_schema}.nfss_tbproduct.estab_date is '产品成立日期';
comment on column ${iol_schema}.nfss_tbproduct.income_date is '产品起息日期';
comment on column ${iol_schema}.nfss_tbproduct.end_date is '产品结束日期';
comment on column ${iol_schema}.nfss_tbproduct.interest_end_date is '利息截止日#';
comment on column ${iol_schema}.nfss_tbproduct.income_end_date is '收益到期日#';
comment on column ${iol_schema}.nfss_tbproduct.issue_fail_date is '募集失败日期#';
comment on column ${iol_schema}.nfss_tbproduct.alimit_end_date is '募集后封闭到期日#';
comment on column ${iol_schema}.nfss_tbproduct.real_estab_date is '实际成立日期#';
comment on column ${iol_schema}.nfss_tbproduct.prd_min_bala is '产品最低募集金额';
comment on column ${iol_schema}.nfss_tbproduct.prd_max_bala is '产品最高募集金额';
comment on column ${iol_schema}.nfss_tbproduct.prd_min_shares is '产品最低募集份额#';
comment on column ${iol_schema}.nfss_tbproduct.prd_max_shares is '产品最高募集份额#';
comment on column ${iol_schema}.nfss_tbproduct.prd_issue_real_bala is '产品实际募集金额#';
comment on column ${iol_schema}.nfss_tbproduct.curr_scale is '当前规模';
comment on column ${iol_schema}.nfss_tbproduct.div_modes is '允许的分红方式';
comment on column ${iol_schema}.nfss_tbproduct.div_mode is '默认分红方式';
comment on column ${iol_schema}.nfss_tbproduct.inst_flag is '销售区域是否控制标志';
comment on column ${iol_schema}.nfss_tbproduct.limit_flag is '额度控制标志';
comment on column ${iol_schema}.nfss_tbproduct.liqu_mode is '募集期帐务模式';
comment on column ${iol_schema}.nfss_tbproduct.liqu_mode2 is '开放期帐务模式';
comment on column ${iol_schema}.nfss_tbproduct.channels is '允许渠道组';
comment on column ${iol_schema}.nfss_tbproduct.client_groups is '允许客户组';
comment on column ${iol_schema}.nfss_tbproduct.temp_flag is '模板标志';
comment on column ${iol_schema}.nfss_tbproduct.control_flag is '控制标志';
comment on column ${iol_schema}.nfss_tbproduct.control_flag2 is 'bta控制标志#';
comment on column ${iol_schema}.nfss_tbproduct.share_class is '前后端收费类别';
comment on column ${iol_schema}.nfss_tbproduct.issue_cfm_rate is '成立确认比例#';
comment on column ${iol_schema}.nfss_tbproduct.sub_mode is '是否外收费';
comment on column ${iol_schema}.nfss_tbproduct.sub_exp is '认购导出模式';
comment on column ${iol_schema}.nfss_tbproduct.interest_way is '收益体现方式';
comment on column ${iol_schema}.nfss_tbproduct.prd_attr is '产品属性';
comment on column ${iol_schema}.nfss_tbproduct.risk_level is '风险等级';
comment on column ${iol_schema}.nfss_tbproduct.grade is '评估等级';
comment on column ${iol_schema}.nfss_tbproduct.status is '产品状态';
comment on column ${iol_schema}.nfss_tbproduct.conv_flag is '转换标志';
comment on column ${iol_schema}.nfss_tbproduct.prd_totvol is '产品当前总份额';
comment on column ${iol_schema}.nfss_tbproduct.tot_nav is '产品累计净值';
comment on column ${iol_schema}.nfss_tbproduct.curr_type is '币种';
comment on column ${iol_schema}.nfss_tbproduct.cost_curr_type is '返还本金币种';
comment on column ${iol_schema}.nfss_tbproduct.income_curr_type is '收益币种';
comment on column ${iol_schema}.nfss_tbproduct.cash_flag is '钞汇标志';
comment on column ${iol_schema}.nfss_tbproduct.agio_type is '折扣率计算方式';
comment on column ${iol_schema}.nfss_tbproduct.open_time is '开市时间';
comment on column ${iol_schema}.nfss_tbproduct.close_time is '闭市时间';
comment on column ${iol_schema}.nfss_tbproduct.paper_no is '产品适合度试卷编号';
comment on column ${iol_schema}.nfss_tbproduct.paper_name is '产品适合度试卷名称';
comment on column ${iol_schema}.nfss_tbproduct.protocol_name is '产品协议书名称';
comment on column ${iol_schema}.nfss_tbproduct.psub_unit is '个人最小购买单位';
comment on column ${iol_schema}.nfss_tbproduct.pfirst_amt is '个人首次最低投资金额';
comment on column ${iol_schema}.nfss_tbproduct.papp_amt is '个人追加最低投资金额';
comment on column ${iol_schema}.nfss_tbproduct.pmin_invest_amt is '个人最低定投金额';
comment on column ${iol_schema}.nfss_tbproduct.pmin_hold is '个人最低持有份额';
comment on column ${iol_schema}.nfss_tbproduct.pmin_red is '个人单笔最少赎回份额';
comment on column ${iol_schema}.nfss_tbproduct.pmax_red is '个人单笔最大赎回份额';
comment on column ${iol_schema}.nfss_tbproduct.pred_unit is '个人赎回单位';
comment on column ${iol_schema}.nfss_tbproduct.pmin_conv_vol is '个人最低基金转换份额';
comment on column ${iol_schema}.nfss_tbproduct.pmin_red_vol is '个人最低定赎份额';
comment on column ${iol_schema}.nfss_tbproduct.pmax_amt is '个人单笔最大购买金额';
comment on column ${iol_schema}.nfss_tbproduct.pmax_accu_amt is '个人单户累计最大购买金额#';
comment on column ${iol_schema}.nfss_tbproduct.osub_unit is '机构最小购买单位';
comment on column ${iol_schema}.nfss_tbproduct.ofirst_amt is '机构首次最低投资金额';
comment on column ${iol_schema}.nfss_tbproduct.oapp_amt is '机构追加最低投资金额';
comment on column ${iol_schema}.nfss_tbproduct.omin_invest_amt is '机构最低定投金额';
comment on column ${iol_schema}.nfss_tbproduct.omin_hold is '机构最低持有份额';
comment on column ${iol_schema}.nfss_tbproduct.omin_red is '机构单笔最小赎回份额';
comment on column ${iol_schema}.nfss_tbproduct.omax_red is '机构单笔最大赎回份额';
comment on column ${iol_schema}.nfss_tbproduct.ored_unit is '机构赎回单位';
comment on column ${iol_schema}.nfss_tbproduct.omin_conv_vol is '机构最低基金转换份额';
comment on column ${iol_schema}.nfss_tbproduct.omin_red_vol is '机构最低定赎份额';
comment on column ${iol_schema}.nfss_tbproduct.omax_amt is '机构单笔最大购买金额';
comment on column ${iol_schema}.nfss_tbproduct.omax_accu_amt is '机构单户累计最大购买金额#';
comment on column ${iol_schema}.nfss_tbproduct.tot_client is '累计购买客户数';
comment on column ${iol_schema}.nfss_tbproduct.ipo_time is '募集开始时间';
comment on column ${iol_schema}.nfss_tbproduct.order_date is '预约购买开始日期';
comment on column ${iol_schema}.nfss_tbproduct.order_time is '预约购买开始时间';
comment on column ${iol_schema}.nfss_tbproduct.book_buy_days is '客户预约购买最大允许提前天数';
comment on column ${iol_schema}.nfss_tbproduct.book_sell_days is '客户预约赎回最大允许提前天数';
comment on column ${iol_schema}.nfss_tbproduct.book_buy_date is '银行指定预约购买受理日';
comment on column ${iol_schema}.nfss_tbproduct.book_sell_date is '银行指定预约赎回受理日';
comment on column ${iol_schema}.nfss_tbproduct.dir_order_type is '定向预约模式';
comment on column ${iol_schema}.nfss_tbproduct.dir_hold_day is '定向预约有效天数';
comment on column ${iol_schema}.nfss_tbproduct.dir_free_date is '定向预约释放日期';
comment on column ${iol_schema}.nfss_tbproduct.dir_start_date is '定向预约开始日期';
comment on column ${iol_schema}.nfss_tbproduct.dir_start_time is '定向预约开始时间';
comment on column ${iol_schema}.nfss_tbproduct.invest_fail_times is '定投失败次数';
comment on column ${iol_schema}.nfss_tbproduct.debit_account is '认申购账号';
comment on column ${iol_schema}.nfss_tbproduct.crebit_account is '赎回账号';
comment on column ${iol_schema}.nfss_tbproduct.red_draw_account is '实时赎回垫支帐号';
comment on column ${iol_schema}.nfss_tbproduct.charge_account is '手续费分配账号';
comment on column ${iol_schema}.nfss_tbproduct.manage_account is '管理费分配账号';
comment on column ${iol_schema}.nfss_tbproduct.red_days is '赎回资金到帐天数';
comment on column ${iol_schema}.nfss_tbproduct.div_days is '分红资金到帐天数';
comment on column ${iol_schema}.nfss_tbproduct.refund_days is '产品到期资金到帐天数';
comment on column ${iol_schema}.nfss_tbproduct.fail_days is '发行失败/比例退款天数';
comment on column ${iol_schema}.nfss_tbproduct.open_buy_days is '申购失败资金到帐延迟天数';
comment on column ${iol_schema}.nfss_tbproduct.red_arr_date is '赎回资金到帐日期';
comment on column ${iol_schema}.nfss_tbproduct.div_arr_date is '分红资金到帐日期';
comment on column ${iol_schema}.nfss_tbproduct.refund_arr_date is '产品到期资金到帐日期';
comment on column ${iol_schema}.nfss_tbproduct.fail_arr_date is '发行失败/比例退款到帐日期';
comment on column ${iol_schema}.nfss_tbproduct.open_arr_date is '申购失败资金到帐延迟日期';
comment on column ${iol_schema}.nfss_tbproduct.large_buy_rate is '超额申购比例#';
comment on column ${iol_schema}.nfss_tbproduct.large_red_rate is '巨额赎回比例#';
comment on column ${iol_schema}.nfss_tbproduct.real_red_amt_rate is '实时赎回资金比例';
comment on column ${iol_schema}.nfss_tbproduct.real_red_vol_rate is '当日实时赎回份额比例上限#';
comment on column ${iol_schema}.nfss_tbproduct.real_red_max_vol is '当日实时赎回份额上限';
comment on column ${iol_schema}.nfss_tbproduct.base_days is '产品计息基数#';
comment on column ${iol_schema}.nfss_tbproduct.interest_days is '认购利息计息基数#';
comment on column ${iol_schema}.nfss_tbproduct.manage_days is '管理费基础天数#';
comment on column ${iol_schema}.nfss_tbproduct.red_fare_rate is '赎回费归基金资产比例#';
comment on column ${iol_schema}.nfss_tbproduct.conv_fare_rate is '转换费归基金资产比例#';
comment on column ${iol_schema}.nfss_tbproduct.manage_rate is '管理费计提比例#';
comment on column ${iol_schema}.nfss_tbproduct.total_bonus is '累计单位分红#';
comment on column ${iol_schema}.nfss_tbproduct.cash_rate is '货币式产品收益兑付频率';
comment on column ${iol_schema}.nfss_tbproduct.money_date is '货币产品收益兑付日期#';
comment on column ${iol_schema}.nfss_tbproduct.corpus_rate is '保本比例#';
comment on column ${iol_schema}.nfss_tbproduct.evend_date is '保本到期日#';
comment on column ${iol_schema}.nfss_tbproduct.tn_confirm is '所有业务清算延后天数#';
comment on column ${iol_schema}.nfss_tbproduct.guest_rate is '预期收益率#';
comment on column ${iol_schema}.nfss_tbproduct.cycle_days is '周期天数#';
comment on column ${iol_schema}.nfss_tbproduct.trans_way is '交易方式';
comment on column ${iol_schema}.nfss_tbproduct.int1 is '备用整数1';
comment on column ${iol_schema}.nfss_tbproduct.int2 is '备用整数2';
comment on column ${iol_schema}.nfss_tbproduct.amt1 is '备用金额1';
comment on column ${iol_schema}.nfss_tbproduct.amt2 is '备用金额2';
comment on column ${iol_schema}.nfss_tbproduct.amt3 is '备用金额3';
comment on column ${iol_schema}.nfss_tbproduct.reserve1 is '备注1';
comment on column ${iol_schema}.nfss_tbproduct.reserve2 is '备注2';
comment on column ${iol_schema}.nfss_tbproduct.reserve3 is '备注3';
comment on column ${iol_schema}.nfss_tbproduct.reserve4 is '备注4';
comment on column ${iol_schema}.nfss_tbproduct.reserve5 is '备注5';
comment on column ${iol_schema}.nfss_tbproduct.start_dt is '开始时间';
comment on column ${iol_schema}.nfss_tbproduct.end_dt is '结束时间';
comment on column ${iol_schema}.nfss_tbproduct.id_mark is '增删标志';
comment on column ${iol_schema}.nfss_tbproduct.etl_timestamp is 'ETL处理时间戳';
