/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol nfss_tbprddailyext
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.nfss_tbprddailyext
whenever sqlerror continue none;
drop table ${iol_schema}.nfss_tbprddailyext purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.nfss_tbprddailyext(
    iss_date number(22,0) -- 发布日期
    ,cfm_date number(22,0) -- 确认日期(当天日期)
    ,prd_code varchar2(30) -- 产品代码
    ,nav_flag varchar2(2) -- 净值类型
    ,nav number(18,8) -- 基金单位净值
    ,tot_vol number(18,3) -- 基金总份数
    ,status varchar2(2) -- 基金状态
    ,prd_name varchar2(375) -- 产品名称
    ,periodic_status varchar2(2) -- 定期定额状态
    ,chg_agc_status varchar2(2) -- 转托管状态
    ,curr_type varchar2(5) -- 结算币种
    ,announc_flag varchar2(2) -- 公告标志
    ,div_mode varchar2(2) -- 默认分红方式
    ,osubfirst_amt number(18,2) -- 机构首次认购最低金额
    ,osubfirst_vol number(18,2) -- 机构首次认购最低份额
    ,osubapp_amt number(18,2) -- 机构追加认购金额
    ,osubapp_vol number(18,2) -- 机构追加认购份额
    ,omaxsub_amt number(18,2) -- 机构最高认购金额
    ,omaxsub_vol number(18,2) -- 机构最高认购份数
    ,osubunit_amt number(18,2) -- 机构认购金额单位
    ,osubunit_vol number(18,2) -- 机构认购份额单位
    ,ofirst_amt number(18,2) -- 机构首次申购最低金额
    ,oapp_amt number(18,2) -- 机构追加申购最低金额
    ,omax_amt number(18,2) -- 机构最大申购金额
    ,omax_accu_amt number(18,2) -- 机构当日累计购买最大金额
    ,omax_accured_amt number(18,2) -- 机构当日累计赎回最大份额
    ,omax_red_vol number(18,2) -- 机构最大赎回份额
    ,psubfirst_amt number(18,2) -- 个人首次认购最低金额
    ,psubfirst_vol number(18,2) -- 个人首次认购最低份额
    ,psubapp_amt number(18,2) -- 个人追加认购金额
    ,psubapp_vol number(18,2) -- 个人追加认购份额
    ,pmaxsub_amt number(18,2) -- 个人最高认购金额
    ,pmaxsub_vol number(18,2) -- 个人最高认购份数
    ,psubunit_amt number(18,2) -- 个人认购金额单位
    ,psubunit_vol number(18,2) -- 个人认购份额单位
    ,pfirst_amt number(18,2) -- 个人首次申购最低金额
    ,papp_amt number(18,2) -- 个人追加申购最低金额
    ,pmax_amt number(18,2) -- 个人最大申购金额
    ,pmax_accu_amt number(18,2) -- 个人当日累计购买最大金额
    ,pmax_accured_amt number(18,2) -- 个人当日累计赎回最大份额
    ,pmax_red_vol number(18,2) -- 个人最大赎回份额
    ,max_red_vol number(18,2) -- 基金最高赎回份额
    ,min_hold_vol number(18,2) -- 基金最低持有份数
    ,min_red_vol number(18,2) -- 基金最少赎回份数
    ,min_conv_vol number(18,2) -- 最低基金转换份数
    ,piss_type varchar2(2) -- 个人发行方式
    ,oiss_type varchar2(2) -- 机构发行方式
    ,invest_amt number(18,2) -- 定投金额
    ,invest_date number(22,0) -- 定投日期
    ,prd_trustee varchar2(5) -- 产品托管人
    ,ipo_start_date number(22,0) -- 募集开始日期
    ,ipo_end_date number(22,0) -- 募集结束日期
    ,divident_date number(22,0) -- 分红日
    ,reg_date number(22,0) -- 权益登记日期
    ,xr_date number(22,0) -- 除权日
    ,sub_type varchar2(2) -- 认购方式
    ,transfee_type varchar2(2) -- 交易费收取方式
    ,price number(18,8) -- 交易价格
    ,next_trade_date number(22,0) -- 下一交易日
    ,value_line number(7,2) -- 产品价值线数值
    ,total_bonus number(18,8) -- 累计单位分红
    ,fundincome_unit number(18,8) -- 货币基金万份收益
    ,fundincome_type varchar2(2) -- 货币基金万份收益正负
    ,yield number(18,8) -- 货币基金七日年化收益率
    ,yield_flag varchar2(2) -- 货币基金七日年化收益率正负
    ,guaranteed_nav number(18,8) -- 保本净值
    ,yearincome_rate number(18,8) -- 货币基金年收益率
    ,yearincome_flag varchar2(2) -- 货币基金年收益率正负
    ,daily_income_flag varchar2(2) -- 基金当日总收益正负
    ,daily_income number(18,2) -- 基金当日总收益
    ,breach_red_flag varchar2(2) -- 允许违约赎回标志
    ,fund_type varchar2(2) -- 基金类型
    ,fund_type_name varchar2(375) -- 基金类型名称
    ,prd_sponsor varchar2(5) -- 产品发起人
    ,ta_code varchar2(14) -- ta代码
    ,ta_name varchar2(375) -- ta名称
    ,prd_manager varchar2(9) -- 产品管理人
    ,prd_manager_name varchar2(375) -- 基金管理人名称
    ,service_tel varchar2(60) -- 基金公司客服电话
    ,internet_address varchar2(375) -- 基金公司网站网址
    ,monthincome_rate number(18,8) -- 月年化收益率
    ,monthincome_flag varchar2(2) -- 月年化收益率正负
    ,quarter_rate number(18,8) -- 季度年化收益率
    ,quarter_rate_flag varchar2(2) -- 季度年化收益率正负
    ,cycle_rate number(18,8) -- 周期收益率
    ,cycle_rate_flag varchar2(2) -- 周期收益率正负
    ,reserve1 varchar2(375) -- 备用1
    ,reserve2 varchar2(375) -- 备用2
    ,reserve3 varchar2(375) -- 备用3
    ,nav_date number(22,0) -- 资管净值日期
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
grant select on ${iol_schema}.nfss_tbprddailyext to ${iml_schema};
grant select on ${iol_schema}.nfss_tbprddailyext to ${icl_schema};
grant select on ${iol_schema}.nfss_tbprddailyext to ${idl_schema};
grant select on ${iol_schema}.nfss_tbprddailyext to ${iel_schema};

-- comment
comment on table ${iol_schema}.nfss_tbprddailyext is '产品日信息扩展表';
comment on column ${iol_schema}.nfss_tbprddailyext.iss_date is '发布日期';
comment on column ${iol_schema}.nfss_tbprddailyext.cfm_date is '确认日期(当天日期)';
comment on column ${iol_schema}.nfss_tbprddailyext.prd_code is '产品代码';
comment on column ${iol_schema}.nfss_tbprddailyext.nav_flag is '净值类型';
comment on column ${iol_schema}.nfss_tbprddailyext.nav is '基金单位净值';
comment on column ${iol_schema}.nfss_tbprddailyext.tot_vol is '基金总份数';
comment on column ${iol_schema}.nfss_tbprddailyext.status is '基金状态';
comment on column ${iol_schema}.nfss_tbprddailyext.prd_name is '产品名称';
comment on column ${iol_schema}.nfss_tbprddailyext.periodic_status is '定期定额状态';
comment on column ${iol_schema}.nfss_tbprddailyext.chg_agc_status is '转托管状态';
comment on column ${iol_schema}.nfss_tbprddailyext.curr_type is '结算币种';
comment on column ${iol_schema}.nfss_tbprddailyext.announc_flag is '公告标志';
comment on column ${iol_schema}.nfss_tbprddailyext.div_mode is '默认分红方式';
comment on column ${iol_schema}.nfss_tbprddailyext.osubfirst_amt is '机构首次认购最低金额';
comment on column ${iol_schema}.nfss_tbprddailyext.osubfirst_vol is '机构首次认购最低份额';
comment on column ${iol_schema}.nfss_tbprddailyext.osubapp_amt is '机构追加认购金额';
comment on column ${iol_schema}.nfss_tbprddailyext.osubapp_vol is '机构追加认购份额';
comment on column ${iol_schema}.nfss_tbprddailyext.omaxsub_amt is '机构最高认购金额';
comment on column ${iol_schema}.nfss_tbprddailyext.omaxsub_vol is '机构最高认购份数';
comment on column ${iol_schema}.nfss_tbprddailyext.osubunit_amt is '机构认购金额单位';
comment on column ${iol_schema}.nfss_tbprddailyext.osubunit_vol is '机构认购份额单位';
comment on column ${iol_schema}.nfss_tbprddailyext.ofirst_amt is '机构首次申购最低金额';
comment on column ${iol_schema}.nfss_tbprddailyext.oapp_amt is '机构追加申购最低金额';
comment on column ${iol_schema}.nfss_tbprddailyext.omax_amt is '机构最大申购金额';
comment on column ${iol_schema}.nfss_tbprddailyext.omax_accu_amt is '机构当日累计购买最大金额';
comment on column ${iol_schema}.nfss_tbprddailyext.omax_accured_amt is '机构当日累计赎回最大份额';
comment on column ${iol_schema}.nfss_tbprddailyext.omax_red_vol is '机构最大赎回份额';
comment on column ${iol_schema}.nfss_tbprddailyext.psubfirst_amt is '个人首次认购最低金额';
comment on column ${iol_schema}.nfss_tbprddailyext.psubfirst_vol is '个人首次认购最低份额';
comment on column ${iol_schema}.nfss_tbprddailyext.psubapp_amt is '个人追加认购金额';
comment on column ${iol_schema}.nfss_tbprddailyext.psubapp_vol is '个人追加认购份额';
comment on column ${iol_schema}.nfss_tbprddailyext.pmaxsub_amt is '个人最高认购金额';
comment on column ${iol_schema}.nfss_tbprddailyext.pmaxsub_vol is '个人最高认购份数';
comment on column ${iol_schema}.nfss_tbprddailyext.psubunit_amt is '个人认购金额单位';
comment on column ${iol_schema}.nfss_tbprddailyext.psubunit_vol is '个人认购份额单位';
comment on column ${iol_schema}.nfss_tbprddailyext.pfirst_amt is '个人首次申购最低金额';
comment on column ${iol_schema}.nfss_tbprddailyext.papp_amt is '个人追加申购最低金额';
comment on column ${iol_schema}.nfss_tbprddailyext.pmax_amt is '个人最大申购金额';
comment on column ${iol_schema}.nfss_tbprddailyext.pmax_accu_amt is '个人当日累计购买最大金额';
comment on column ${iol_schema}.nfss_tbprddailyext.pmax_accured_amt is '个人当日累计赎回最大份额';
comment on column ${iol_schema}.nfss_tbprddailyext.pmax_red_vol is '个人最大赎回份额';
comment on column ${iol_schema}.nfss_tbprddailyext.max_red_vol is '基金最高赎回份额';
comment on column ${iol_schema}.nfss_tbprddailyext.min_hold_vol is '基金最低持有份数';
comment on column ${iol_schema}.nfss_tbprddailyext.min_red_vol is '基金最少赎回份数';
comment on column ${iol_schema}.nfss_tbprddailyext.min_conv_vol is '最低基金转换份数';
comment on column ${iol_schema}.nfss_tbprddailyext.piss_type is '个人发行方式';
comment on column ${iol_schema}.nfss_tbprddailyext.oiss_type is '机构发行方式';
comment on column ${iol_schema}.nfss_tbprddailyext.invest_amt is '定投金额';
comment on column ${iol_schema}.nfss_tbprddailyext.invest_date is '定投日期';
comment on column ${iol_schema}.nfss_tbprddailyext.prd_trustee is '产品托管人';
comment on column ${iol_schema}.nfss_tbprddailyext.ipo_start_date is '募集开始日期';
comment on column ${iol_schema}.nfss_tbprddailyext.ipo_end_date is '募集结束日期';
comment on column ${iol_schema}.nfss_tbprddailyext.divident_date is '分红日';
comment on column ${iol_schema}.nfss_tbprddailyext.reg_date is '权益登记日期';
comment on column ${iol_schema}.nfss_tbprddailyext.xr_date is '除权日';
comment on column ${iol_schema}.nfss_tbprddailyext.sub_type is '认购方式';
comment on column ${iol_schema}.nfss_tbprddailyext.transfee_type is '交易费收取方式';
comment on column ${iol_schema}.nfss_tbprddailyext.price is '交易价格';
comment on column ${iol_schema}.nfss_tbprddailyext.next_trade_date is '下一交易日';
comment on column ${iol_schema}.nfss_tbprddailyext.value_line is '产品价值线数值';
comment on column ${iol_schema}.nfss_tbprddailyext.total_bonus is '累计单位分红';
comment on column ${iol_schema}.nfss_tbprddailyext.fundincome_unit is '货币基金万份收益';
comment on column ${iol_schema}.nfss_tbprddailyext.fundincome_type is '货币基金万份收益正负';
comment on column ${iol_schema}.nfss_tbprddailyext.yield is '货币基金七日年化收益率';
comment on column ${iol_schema}.nfss_tbprddailyext.yield_flag is '货币基金七日年化收益率正负';
comment on column ${iol_schema}.nfss_tbprddailyext.guaranteed_nav is '保本净值';
comment on column ${iol_schema}.nfss_tbprddailyext.yearincome_rate is '货币基金年收益率';
comment on column ${iol_schema}.nfss_tbprddailyext.yearincome_flag is '货币基金年收益率正负';
comment on column ${iol_schema}.nfss_tbprddailyext.daily_income_flag is '基金当日总收益正负';
comment on column ${iol_schema}.nfss_tbprddailyext.daily_income is '基金当日总收益';
comment on column ${iol_schema}.nfss_tbprddailyext.breach_red_flag is '允许违约赎回标志';
comment on column ${iol_schema}.nfss_tbprddailyext.fund_type is '基金类型';
comment on column ${iol_schema}.nfss_tbprddailyext.fund_type_name is '基金类型名称';
comment on column ${iol_schema}.nfss_tbprddailyext.prd_sponsor is '产品发起人';
comment on column ${iol_schema}.nfss_tbprddailyext.ta_code is 'ta代码';
comment on column ${iol_schema}.nfss_tbprddailyext.ta_name is 'ta名称';
comment on column ${iol_schema}.nfss_tbprddailyext.prd_manager is '产品管理人';
comment on column ${iol_schema}.nfss_tbprddailyext.prd_manager_name is '基金管理人名称';
comment on column ${iol_schema}.nfss_tbprddailyext.service_tel is '基金公司客服电话';
comment on column ${iol_schema}.nfss_tbprddailyext.internet_address is '基金公司网站网址';
comment on column ${iol_schema}.nfss_tbprddailyext.monthincome_rate is '月年化收益率';
comment on column ${iol_schema}.nfss_tbprddailyext.monthincome_flag is '月年化收益率正负';
comment on column ${iol_schema}.nfss_tbprddailyext.quarter_rate is '季度年化收益率';
comment on column ${iol_schema}.nfss_tbprddailyext.quarter_rate_flag is '季度年化收益率正负';
comment on column ${iol_schema}.nfss_tbprddailyext.cycle_rate is '周期收益率';
comment on column ${iol_schema}.nfss_tbprddailyext.cycle_rate_flag is '周期收益率正负';
comment on column ${iol_schema}.nfss_tbprddailyext.reserve1 is '备用1';
comment on column ${iol_schema}.nfss_tbprddailyext.reserve2 is '备用2';
comment on column ${iol_schema}.nfss_tbprddailyext.reserve3 is '备用3';
comment on column ${iol_schema}.nfss_tbprddailyext.nav_date is '资管净值日期';
comment on column ${iol_schema}.nfss_tbprddailyext.start_dt is '开始时间';
comment on column ${iol_schema}.nfss_tbprddailyext.end_dt is '结束时间';
comment on column ${iol_schema}.nfss_tbprddailyext.id_mark is '增删标志';
comment on column ${iol_schema}.nfss_tbprddailyext.etl_timestamp is 'ETL处理时间戳';
