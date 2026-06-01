/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol mpcs_a92fund
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.mpcs_a92fund
whenever sqlerror continue none;
drop table ${iol_schema}.mpcs_a92fund purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.mpcs_a92fund(
    paysys varchar2(15) -- 服务方简称
    ,instid varchar2(15) -- 接入商户号
    ,fundcode varchar2(45) -- 基金代码
    ,fundfullname varchar2(150) -- 基金全称
    ,fundname varchar2(150) -- 基金简称
    ,fundtype varchar2(2) -- 基金类型 0-其他类型 1-股票型 2-债券型 3-混合型 4-货币型 5-保本型 6-指数型 7-qdii 8-商品型 9-短期理财
    ,risklevel varchar2(2) -- 风险等级 5-激进型,4-进取型,3-稳健型,2-谨慎型,1-保守型 0-未评级
    ,confirmpace number(22) -- 确认天数
    ,refundpace number(22) -- 赎回到账天数
    ,defaultdividendmethod varchar2(2) -- 默认分红方式 0-红利资金再投 1-现金分红
    ,currency varchar2(5) -- 币种 156-人民币
    ,salestat varchar2(2) -- 销售状态  0:不代销（下架） 1:代销（上架）
    ,sharetype varchar2(15) -- 收费类型a-前端收费  b-后端收费 c-c类收费
    ,supportperiodic varchar2(2) -- 定投开通标志0:未开通  1:开通
    ,supportconvert varchar2(2) -- 转换开通标志 0:未开通  1:开通
    ,managerrate number(12,6) -- 管理费率
    ,trusteerate number(12,6) -- 托管费率
    ,subscriberate varchar2(3072) -- 前端认购费率
    ,allotrate varchar2(3072) -- 前端申购费率
    ,redeemrate varchar2(3072) -- 赎回费率
    ,minindivisubscribeamount number(17,4) -- 个人首次认购最低金额
    ,minindiviappendsubscribeamount number(17,4) -- 个人追加认购最低金额
    ,maxindivisubscribeamount number(17,4) -- 个人最高认购金额
    ,minindiviallotamount number(17,4) -- 个人首次申购最低金额
    ,minindiviappendallotamount number(17,4) -- 个人追加申购最低金额
    ,maxindiviallotamount number(17,4) -- 个人最高申购金额
    ,minindiviperiodicamount number(17,4) -- 个人定投申购最低金额
    ,maxindiviperiodicamount number(17,4) -- 个人定投申购最高金额
    ,minindiviholdvol number(17,4) -- 个人持有最低份额
    ,minindiviredeemvol number(17,4) -- 个人赎回最低份额
    ,minindiviconvertvol number(17,4) -- 个人转换最低份额
    ,setupdate varchar2(12) -- 成立日期
    ,fundcorp varchar2(3072) -- 管理人
    ,trustee varchar2(150) -- 托管人
    ,fundmanager varchar2(3072) -- 基金经理
    ,reportdate varchar2(12) -- 报告日期
    ,assetamount varchar2(3072) -- 资产规模
    ,assetvol varchar2(3072) -- 份额规模
    ,stockportfolio varchar2(3072) -- 十大重仓股
    ,industryportfolio varchar2(3072) -- 行业配置
    ,assetportfolio varchar2(3072) -- 资产配置
    ,uptdividendmethodflg varchar2(2) -- 是否可修改分红方式
    ,salerate number(12,6) -- 销售服务费
    ,ecflag varchar2(2) -- 是否签订电子合同 0 - 不需要 1 － 需要
    ,prodtype varchar2(2) -- 产品类型1-开放型公募基金 2-封闭型公募基金 3-私募 4-专户 5-券商资管产品
    ,supportallot varchar2(2) -- 申购开通标志 0：不可以购买 1：可以申购
    ,supportsubscribe varchar2(2) -- 认购开通标志 0：不可以购买 1：可以认购
    ,supportbuy varchar2(2) -- 购买开通标志 0：不可以购买  1：可以购买
    ,nonstdredeemfee varchar2(3072) -- 非标准赎回费
    ,recommendflag number(22) -- 推荐标识
    ,uptdatetime varchar2(21) -- 更新时间
    ,reserve1 varchar2(75) -- 备用字段1
    ,reserve2 varchar2(75) -- 备用字段2
    ,reserve3 varchar2(150) -- 备用字段3
    ,reserve4 varchar2(150) -- 备用字段4
    ,reserve5 varchar2(375) -- 备用字段5
    ,reserve6 varchar2(375) -- 备用字段6
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
grant select on ${iol_schema}.mpcs_a92fund to ${iml_schema};
grant select on ${iol_schema}.mpcs_a92fund to ${icl_schema};
grant select on ${iol_schema}.mpcs_a92fund to ${idl_schema};
grant select on ${iol_schema}.mpcs_a92fund to ${iel_schema};

-- comment
comment on table ${iol_schema}.mpcs_a92fund is '基金信息表';
comment on column ${iol_schema}.mpcs_a92fund.paysys is '服务方简称';
comment on column ${iol_schema}.mpcs_a92fund.instid is '接入商户号';
comment on column ${iol_schema}.mpcs_a92fund.fundcode is '基金代码';
comment on column ${iol_schema}.mpcs_a92fund.fundfullname is '基金全称';
comment on column ${iol_schema}.mpcs_a92fund.fundname is '基金简称';
comment on column ${iol_schema}.mpcs_a92fund.fundtype is '基金类型 0-其他类型 1-股票型 2-债券型 3-混合型 4-货币型 5-保本型 6-指数型 7-qdii 8-商品型 9-短期理财';
comment on column ${iol_schema}.mpcs_a92fund.risklevel is '风险等级 5-激进型,4-进取型,3-稳健型,2-谨慎型,1-保守型 0-未评级';
comment on column ${iol_schema}.mpcs_a92fund.confirmpace is '确认天数';
comment on column ${iol_schema}.mpcs_a92fund.refundpace is '赎回到账天数';
comment on column ${iol_schema}.mpcs_a92fund.defaultdividendmethod is '默认分红方式 0-红利资金再投 1-现金分红';
comment on column ${iol_schema}.mpcs_a92fund.currency is '币种 156-人民币';
comment on column ${iol_schema}.mpcs_a92fund.salestat is '销售状态  0:不代销（下架） 1:代销（上架）';
comment on column ${iol_schema}.mpcs_a92fund.sharetype is '收费类型a-前端收费  b-后端收费 c-c类收费';
comment on column ${iol_schema}.mpcs_a92fund.supportperiodic is '定投开通标志0:未开通  1:开通';
comment on column ${iol_schema}.mpcs_a92fund.supportconvert is '转换开通标志 0:未开通  1:开通';
comment on column ${iol_schema}.mpcs_a92fund.managerrate is '管理费率';
comment on column ${iol_schema}.mpcs_a92fund.trusteerate is '托管费率';
comment on column ${iol_schema}.mpcs_a92fund.subscriberate is '前端认购费率';
comment on column ${iol_schema}.mpcs_a92fund.allotrate is '前端申购费率';
comment on column ${iol_schema}.mpcs_a92fund.redeemrate is '赎回费率';
comment on column ${iol_schema}.mpcs_a92fund.minindivisubscribeamount is '个人首次认购最低金额';
comment on column ${iol_schema}.mpcs_a92fund.minindiviappendsubscribeamount is '个人追加认购最低金额';
comment on column ${iol_schema}.mpcs_a92fund.maxindivisubscribeamount is '个人最高认购金额';
comment on column ${iol_schema}.mpcs_a92fund.minindiviallotamount is '个人首次申购最低金额';
comment on column ${iol_schema}.mpcs_a92fund.minindiviappendallotamount is '个人追加申购最低金额';
comment on column ${iol_schema}.mpcs_a92fund.maxindiviallotamount is '个人最高申购金额';
comment on column ${iol_schema}.mpcs_a92fund.minindiviperiodicamount is '个人定投申购最低金额';
comment on column ${iol_schema}.mpcs_a92fund.maxindiviperiodicamount is '个人定投申购最高金额';
comment on column ${iol_schema}.mpcs_a92fund.minindiviholdvol is '个人持有最低份额';
comment on column ${iol_schema}.mpcs_a92fund.minindiviredeemvol is '个人赎回最低份额';
comment on column ${iol_schema}.mpcs_a92fund.minindiviconvertvol is '个人转换最低份额';
comment on column ${iol_schema}.mpcs_a92fund.setupdate is '成立日期';
comment on column ${iol_schema}.mpcs_a92fund.fundcorp is '管理人';
comment on column ${iol_schema}.mpcs_a92fund.trustee is '托管人';
comment on column ${iol_schema}.mpcs_a92fund.fundmanager is '基金经理';
comment on column ${iol_schema}.mpcs_a92fund.reportdate is '报告日期';
comment on column ${iol_schema}.mpcs_a92fund.assetamount is '资产规模';
comment on column ${iol_schema}.mpcs_a92fund.assetvol is '份额规模';
comment on column ${iol_schema}.mpcs_a92fund.stockportfolio is '十大重仓股';
comment on column ${iol_schema}.mpcs_a92fund.industryportfolio is '行业配置';
comment on column ${iol_schema}.mpcs_a92fund.assetportfolio is '资产配置';
comment on column ${iol_schema}.mpcs_a92fund.uptdividendmethodflg is '是否可修改分红方式';
comment on column ${iol_schema}.mpcs_a92fund.salerate is '销售服务费';
comment on column ${iol_schema}.mpcs_a92fund.ecflag is '是否签订电子合同 0 - 不需要 1 － 需要';
comment on column ${iol_schema}.mpcs_a92fund.prodtype is '产品类型1-开放型公募基金 2-封闭型公募基金 3-私募 4-专户 5-券商资管产品';
comment on column ${iol_schema}.mpcs_a92fund.supportallot is '申购开通标志 0：不可以购买 1：可以申购';
comment on column ${iol_schema}.mpcs_a92fund.supportsubscribe is '认购开通标志 0：不可以购买 1：可以认购';
comment on column ${iol_schema}.mpcs_a92fund.supportbuy is '购买开通标志 0：不可以购买  1：可以购买';
comment on column ${iol_schema}.mpcs_a92fund.nonstdredeemfee is '非标准赎回费';
comment on column ${iol_schema}.mpcs_a92fund.recommendflag is '推荐标识';
comment on column ${iol_schema}.mpcs_a92fund.uptdatetime is '更新时间';
comment on column ${iol_schema}.mpcs_a92fund.reserve1 is '备用字段1';
comment on column ${iol_schema}.mpcs_a92fund.reserve2 is '备用字段2';
comment on column ${iol_schema}.mpcs_a92fund.reserve3 is '备用字段3';
comment on column ${iol_schema}.mpcs_a92fund.reserve4 is '备用字段4';
comment on column ${iol_schema}.mpcs_a92fund.reserve5 is '备用字段5';
comment on column ${iol_schema}.mpcs_a92fund.reserve6 is '备用字段6';
comment on column ${iol_schema}.mpcs_a92fund.start_dt is '开始时间';
comment on column ${iol_schema}.mpcs_a92fund.end_dt is '结束时间';
comment on column ${iol_schema}.mpcs_a92fund.id_mark is '增删标志';
comment on column ${iol_schema}.mpcs_a92fund.etl_timestamp is 'ETL处理时间戳';
