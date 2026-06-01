/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_mpcs_a92fund
CreateDate: 20180515
Logs:
    zjj 2018-05-15 新建脚本
*/

set timing on

-- 1 alter parallel
alter session force parallel query parallel 8;
alter session force parallel dml parallel 8;
-- alter session force parallel ddl parallel 8;

-- 2.1 create backup table
-- if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iol_schema}.mpcs_a92fund_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.mpcs_a92fund
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.mpcs_a92fund_op purge;
drop table ${iol_schema}.mpcs_a92fund_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.mpcs_a92fund_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.mpcs_a92fund where 0=1;

create table ${iol_schema}.mpcs_a92fund_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.mpcs_a92fund where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.mpcs_a92fund_cl(
            paysys -- 服务方简称
            ,instid -- 接入商户号
            ,fundcode -- 基金代码
            ,fundfullname -- 基金全称
            ,fundname -- 基金简称
            ,fundtype -- 基金类型 0-其他类型 1-股票型 2-债券型 3-混合型 4-货币型 5-保本型 6-指数型 7-QDII 8-商品型 9-短期理财
            ,risklevel -- 风险等级 5-激进型,4-进取型,3-稳健型,2-谨慎型,1-保守型 0-未评级
            ,confirmpace -- 确认天数
            ,refundpace -- 赎回到账天数
            ,defaultdividendmethod -- 默认分红方式 0-红利资金再投 1-现金分红
            ,currency -- 币种 156-人民币
            ,salestat -- 销售状态  0:不代销（下架） 1:代销（上架）
            ,sharetype -- 收费类型A-前端收费  B-后端收费 C-C类收费
            ,supportperiodic -- 定投开通标志0:未开通  1:开通
            ,supportconvert -- 转换开通标志 0:未开通  1:开通
            ,managerrate -- 管理费率
            ,trusteerate -- 托管费率
            ,subscriberate -- 前端认购费率
            ,allotrate -- 前端申购费率
            ,redeemrate -- 赎回费率
            ,minindivisubscribeamount -- 个人首次认购最低金额
            ,minindiviappendsubscribeamount -- 个人追加认购最低金额
            ,maxindivisubscribeamount -- 个人最高认购金额
            ,minindiviallotamount -- 个人首次申购最低金额
            ,minindiviappendallotamount -- 个人追加申购最低金额
            ,maxindiviallotamount -- 个人最高申购金额
            ,minindiviperiodicamount -- 个人定投申购最低金额
            ,maxindiviperiodicamount -- 个人定投申购最高金额
            ,minindiviholdvol -- 个人持有最低份额
            ,minindiviredeemvol -- 个人赎回最低份额
            ,minindiviconvertvol -- 个人转换最低份额
            ,setupdate -- 成立日期
            ,fundcorp -- 管理人
            ,trustee -- 托管人
            ,fundmanager -- 基金经理
            ,reportdate -- 报告日期
            ,assetamount -- 资产规模
            ,assetvol -- 份额规模
            ,stockportfolio -- 十大重仓股
            ,industryportfolio -- 行业配置
            ,assetportfolio -- 资产配置
            ,uptdividendmethodflg -- 是否可修改分红方式
            ,salerate -- 销售服务费
            ,ecflag -- 是否签订电子合同 0 - 不需要 1 － 需要
            ,prodtype -- 产品类型1-开放型公募基金 2-封闭型公募基金 3-私募 4-专户 5-券商资管产品
            ,supportallot -- 申购开通标志 0：不可以购买 1：可以申购
            ,supportsubscribe -- 认购开通标志 0：不可以购买 1：可以认购
            ,supportbuy -- 购买开通标志 0：不可以购买  1：可以购买
            ,nonstdredeemfee -- 非标准赎回费
            ,recommendflag -- 推荐标识
            ,uptdatetime -- 更新时间
            ,reserve1 -- 备用字段1
            ,reserve2 -- 备用字段2
            ,reserve3 -- 备用字段3
            ,reserve4 -- 备用字段4
            ,reserve5 -- 备用字段5
            ,reserve6 -- 备用字段6
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.mpcs_a92fund_op(
            paysys -- 服务方简称
            ,instid -- 接入商户号
            ,fundcode -- 基金代码
            ,fundfullname -- 基金全称
            ,fundname -- 基金简称
            ,fundtype -- 基金类型 0-其他类型 1-股票型 2-债券型 3-混合型 4-货币型 5-保本型 6-指数型 7-QDII 8-商品型 9-短期理财
            ,risklevel -- 风险等级 5-激进型,4-进取型,3-稳健型,2-谨慎型,1-保守型 0-未评级
            ,confirmpace -- 确认天数
            ,refundpace -- 赎回到账天数
            ,defaultdividendmethod -- 默认分红方式 0-红利资金再投 1-现金分红
            ,currency -- 币种 156-人民币
            ,salestat -- 销售状态  0:不代销（下架） 1:代销（上架）
            ,sharetype -- 收费类型A-前端收费  B-后端收费 C-C类收费
            ,supportperiodic -- 定投开通标志0:未开通  1:开通
            ,supportconvert -- 转换开通标志 0:未开通  1:开通
            ,managerrate -- 管理费率
            ,trusteerate -- 托管费率
            ,subscriberate -- 前端认购费率
            ,allotrate -- 前端申购费率
            ,redeemrate -- 赎回费率
            ,minindivisubscribeamount -- 个人首次认购最低金额
            ,minindiviappendsubscribeamount -- 个人追加认购最低金额
            ,maxindivisubscribeamount -- 个人最高认购金额
            ,minindiviallotamount -- 个人首次申购最低金额
            ,minindiviappendallotamount -- 个人追加申购最低金额
            ,maxindiviallotamount -- 个人最高申购金额
            ,minindiviperiodicamount -- 个人定投申购最低金额
            ,maxindiviperiodicamount -- 个人定投申购最高金额
            ,minindiviholdvol -- 个人持有最低份额
            ,minindiviredeemvol -- 个人赎回最低份额
            ,minindiviconvertvol -- 个人转换最低份额
            ,setupdate -- 成立日期
            ,fundcorp -- 管理人
            ,trustee -- 托管人
            ,fundmanager -- 基金经理
            ,reportdate -- 报告日期
            ,assetamount -- 资产规模
            ,assetvol -- 份额规模
            ,stockportfolio -- 十大重仓股
            ,industryportfolio -- 行业配置
            ,assetportfolio -- 资产配置
            ,uptdividendmethodflg -- 是否可修改分红方式
            ,salerate -- 销售服务费
            ,ecflag -- 是否签订电子合同 0 - 不需要 1 － 需要
            ,prodtype -- 产品类型1-开放型公募基金 2-封闭型公募基金 3-私募 4-专户 5-券商资管产品
            ,supportallot -- 申购开通标志 0：不可以购买 1：可以申购
            ,supportsubscribe -- 认购开通标志 0：不可以购买 1：可以认购
            ,supportbuy -- 购买开通标志 0：不可以购买  1：可以购买
            ,nonstdredeemfee -- 非标准赎回费
            ,recommendflag -- 推荐标识
            ,uptdatetime -- 更新时间
            ,reserve1 -- 备用字段1
            ,reserve2 -- 备用字段2
            ,reserve3 -- 备用字段3
            ,reserve4 -- 备用字段4
            ,reserve5 -- 备用字段5
            ,reserve6 -- 备用字段6
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.paysys, o.paysys) as paysys -- 服务方简称
    ,nvl(n.instid, o.instid) as instid -- 接入商户号
    ,nvl(n.fundcode, o.fundcode) as fundcode -- 基金代码
    ,nvl(n.fundfullname, o.fundfullname) as fundfullname -- 基金全称
    ,nvl(n.fundname, o.fundname) as fundname -- 基金简称
    ,nvl(n.fundtype, o.fundtype) as fundtype -- 基金类型 0-其他类型 1-股票型 2-债券型 3-混合型 4-货币型 5-保本型 6-指数型 7-QDII 8-商品型 9-短期理财
    ,nvl(n.risklevel, o.risklevel) as risklevel -- 风险等级 5-激进型,4-进取型,3-稳健型,2-谨慎型,1-保守型 0-未评级
    ,nvl(n.confirmpace, o.confirmpace) as confirmpace -- 确认天数
    ,nvl(n.refundpace, o.refundpace) as refundpace -- 赎回到账天数
    ,nvl(n.defaultdividendmethod, o.defaultdividendmethod) as defaultdividendmethod -- 默认分红方式 0-红利资金再投 1-现金分红
    ,nvl(n.currency, o.currency) as currency -- 币种 156-人民币
    ,nvl(n.salestat, o.salestat) as salestat -- 销售状态  0:不代销（下架） 1:代销（上架）
    ,nvl(n.sharetype, o.sharetype) as sharetype -- 收费类型A-前端收费  B-后端收费 C-C类收费
    ,nvl(n.supportperiodic, o.supportperiodic) as supportperiodic -- 定投开通标志0:未开通  1:开通
    ,nvl(n.supportconvert, o.supportconvert) as supportconvert -- 转换开通标志 0:未开通  1:开通
    ,nvl(n.managerrate, o.managerrate) as managerrate -- 管理费率
    ,nvl(n.trusteerate, o.trusteerate) as trusteerate -- 托管费率
    ,nvl(n.subscriberate, o.subscriberate) as subscriberate -- 前端认购费率
    ,nvl(n.allotrate, o.allotrate) as allotrate -- 前端申购费率
    ,nvl(n.redeemrate, o.redeemrate) as redeemrate -- 赎回费率
    ,nvl(n.minindivisubscribeamount, o.minindivisubscribeamount) as minindivisubscribeamount -- 个人首次认购最低金额
    ,nvl(n.minindiviappendsubscribeamount, o.minindiviappendsubscribeamount) as minindiviappendsubscribeamount -- 个人追加认购最低金额
    ,nvl(n.maxindivisubscribeamount, o.maxindivisubscribeamount) as maxindivisubscribeamount -- 个人最高认购金额
    ,nvl(n.minindiviallotamount, o.minindiviallotamount) as minindiviallotamount -- 个人首次申购最低金额
    ,nvl(n.minindiviappendallotamount, o.minindiviappendallotamount) as minindiviappendallotamount -- 个人追加申购最低金额
    ,nvl(n.maxindiviallotamount, o.maxindiviallotamount) as maxindiviallotamount -- 个人最高申购金额
    ,nvl(n.minindiviperiodicamount, o.minindiviperiodicamount) as minindiviperiodicamount -- 个人定投申购最低金额
    ,nvl(n.maxindiviperiodicamount, o.maxindiviperiodicamount) as maxindiviperiodicamount -- 个人定投申购最高金额
    ,nvl(n.minindiviholdvol, o.minindiviholdvol) as minindiviholdvol -- 个人持有最低份额
    ,nvl(n.minindiviredeemvol, o.minindiviredeemvol) as minindiviredeemvol -- 个人赎回最低份额
    ,nvl(n.minindiviconvertvol, o.minindiviconvertvol) as minindiviconvertvol -- 个人转换最低份额
    ,nvl(n.setupdate, o.setupdate) as setupdate -- 成立日期
    ,nvl(n.fundcorp, o.fundcorp) as fundcorp -- 管理人
    ,nvl(n.trustee, o.trustee) as trustee -- 托管人
    ,nvl(n.fundmanager, o.fundmanager) as fundmanager -- 基金经理
    ,nvl(n.reportdate, o.reportdate) as reportdate -- 报告日期
    ,nvl(n.assetamount, o.assetamount) as assetamount -- 资产规模
    ,nvl(n.assetvol, o.assetvol) as assetvol -- 份额规模
    ,nvl(n.stockportfolio, o.stockportfolio) as stockportfolio -- 十大重仓股
    ,nvl(n.industryportfolio, o.industryportfolio) as industryportfolio -- 行业配置
    ,nvl(n.assetportfolio, o.assetportfolio) as assetportfolio -- 资产配置
    ,nvl(n.uptdividendmethodflg, o.uptdividendmethodflg) as uptdividendmethodflg -- 是否可修改分红方式
    ,nvl(n.salerate, o.salerate) as salerate -- 销售服务费
    ,nvl(n.ecflag, o.ecflag) as ecflag -- 是否签订电子合同 0 - 不需要 1 － 需要
    ,nvl(n.prodtype, o.prodtype) as prodtype -- 产品类型1-开放型公募基金 2-封闭型公募基金 3-私募 4-专户 5-券商资管产品
    ,nvl(n.supportallot, o.supportallot) as supportallot -- 申购开通标志 0：不可以购买 1：可以申购
    ,nvl(n.supportsubscribe, o.supportsubscribe) as supportsubscribe -- 认购开通标志 0：不可以购买 1：可以认购
    ,nvl(n.supportbuy, o.supportbuy) as supportbuy -- 购买开通标志 0：不可以购买  1：可以购买
    ,nvl(n.nonstdredeemfee, o.nonstdredeemfee) as nonstdredeemfee -- 非标准赎回费
    ,nvl(n.recommendflag, o.recommendflag) as recommendflag -- 推荐标识
    ,nvl(n.uptdatetime, o.uptdatetime) as uptdatetime -- 更新时间
    ,nvl(n.reserve1, o.reserve1) as reserve1 -- 备用字段1
    ,nvl(n.reserve2, o.reserve2) as reserve2 -- 备用字段2
    ,nvl(n.reserve3, o.reserve3) as reserve3 -- 备用字段3
    ,nvl(n.reserve4, o.reserve4) as reserve4 -- 备用字段4
    ,nvl(n.reserve5, o.reserve5) as reserve5 -- 备用字段5
    ,nvl(n.reserve6, o.reserve6) as reserve6 -- 备用字段6
    ,case when
            n.fundcode is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.fundcode is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.fundcode is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.mpcs_a92fund_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.mpcs_a92fund where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.fundcode = n.fundcode
where (
        o.fundcode is null
    )
    or (
        n.fundcode is null
    )
    or (
        o.paysys <> n.paysys
        or o.instid <> n.instid
        or o.fundfullname <> n.fundfullname
        or o.fundname <> n.fundname
        or o.fundtype <> n.fundtype
        or o.risklevel <> n.risklevel
        or o.confirmpace <> n.confirmpace
        or o.refundpace <> n.refundpace
        or o.defaultdividendmethod <> n.defaultdividendmethod
        or o.currency <> n.currency
        or o.salestat <> n.salestat
        or o.sharetype <> n.sharetype
        or o.supportperiodic <> n.supportperiodic
        or o.supportconvert <> n.supportconvert
        or o.managerrate <> n.managerrate
        or o.trusteerate <> n.trusteerate
        or o.subscriberate <> n.subscriberate
        or o.allotrate <> n.allotrate
        or o.redeemrate <> n.redeemrate
        or o.minindivisubscribeamount <> n.minindivisubscribeamount
        or o.minindiviappendsubscribeamount <> n.minindiviappendsubscribeamount
        or o.maxindivisubscribeamount <> n.maxindivisubscribeamount
        or o.minindiviallotamount <> n.minindiviallotamount
        or o.minindiviappendallotamount <> n.minindiviappendallotamount
        or o.maxindiviallotamount <> n.maxindiviallotamount
        or o.minindiviperiodicamount <> n.minindiviperiodicamount
        or o.maxindiviperiodicamount <> n.maxindiviperiodicamount
        or o.minindiviholdvol <> n.minindiviholdvol
        or o.minindiviredeemvol <> n.minindiviredeemvol
        or o.minindiviconvertvol <> n.minindiviconvertvol
        or o.setupdate <> n.setupdate
        or o.fundcorp <> n.fundcorp
        or o.trustee <> n.trustee
        or o.fundmanager <> n.fundmanager
        or o.reportdate <> n.reportdate
        or o.assetamount <> n.assetamount
        or o.assetvol <> n.assetvol
        or o.stockportfolio <> n.stockportfolio
        or o.industryportfolio <> n.industryportfolio
        or o.assetportfolio <> n.assetportfolio
        or o.uptdividendmethodflg <> n.uptdividendmethodflg
        or o.salerate <> n.salerate
        or o.ecflag <> n.ecflag
        or o.prodtype <> n.prodtype
        or o.supportallot <> n.supportallot
        or o.supportsubscribe <> n.supportsubscribe
        or o.supportbuy <> n.supportbuy
        or o.nonstdredeemfee <> n.nonstdredeemfee
        or o.recommendflag <> n.recommendflag
        or o.uptdatetime <> n.uptdatetime
        or o.reserve1 <> n.reserve1
        or o.reserve2 <> n.reserve2
        or o.reserve3 <> n.reserve3
        or o.reserve4 <> n.reserve4
        or o.reserve5 <> n.reserve5
        or o.reserve6 <> n.reserve6
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.mpcs_a92fund_cl(
            paysys -- 服务方简称
            ,instid -- 接入商户号
            ,fundcode -- 基金代码
            ,fundfullname -- 基金全称
            ,fundname -- 基金简称
            ,fundtype -- 基金类型 0-其他类型 1-股票型 2-债券型 3-混合型 4-货币型 5-保本型 6-指数型 7-QDII 8-商品型 9-短期理财
            ,risklevel -- 风险等级 5-激进型,4-进取型,3-稳健型,2-谨慎型,1-保守型 0-未评级
            ,confirmpace -- 确认天数
            ,refundpace -- 赎回到账天数
            ,defaultdividendmethod -- 默认分红方式 0-红利资金再投 1-现金分红
            ,currency -- 币种 156-人民币
            ,salestat -- 销售状态  0:不代销（下架） 1:代销（上架）
            ,sharetype -- 收费类型A-前端收费  B-后端收费 C-C类收费
            ,supportperiodic -- 定投开通标志0:未开通  1:开通
            ,supportconvert -- 转换开通标志 0:未开通  1:开通
            ,managerrate -- 管理费率
            ,trusteerate -- 托管费率
            ,subscriberate -- 前端认购费率
            ,allotrate -- 前端申购费率
            ,redeemrate -- 赎回费率
            ,minindivisubscribeamount -- 个人首次认购最低金额
            ,minindiviappendsubscribeamount -- 个人追加认购最低金额
            ,maxindivisubscribeamount -- 个人最高认购金额
            ,minindiviallotamount -- 个人首次申购最低金额
            ,minindiviappendallotamount -- 个人追加申购最低金额
            ,maxindiviallotamount -- 个人最高申购金额
            ,minindiviperiodicamount -- 个人定投申购最低金额
            ,maxindiviperiodicamount -- 个人定投申购最高金额
            ,minindiviholdvol -- 个人持有最低份额
            ,minindiviredeemvol -- 个人赎回最低份额
            ,minindiviconvertvol -- 个人转换最低份额
            ,setupdate -- 成立日期
            ,fundcorp -- 管理人
            ,trustee -- 托管人
            ,fundmanager -- 基金经理
            ,reportdate -- 报告日期
            ,assetamount -- 资产规模
            ,assetvol -- 份额规模
            ,stockportfolio -- 十大重仓股
            ,industryportfolio -- 行业配置
            ,assetportfolio -- 资产配置
            ,uptdividendmethodflg -- 是否可修改分红方式
            ,salerate -- 销售服务费
            ,ecflag -- 是否签订电子合同 0 - 不需要 1 － 需要
            ,prodtype -- 产品类型1-开放型公募基金 2-封闭型公募基金 3-私募 4-专户 5-券商资管产品
            ,supportallot -- 申购开通标志 0：不可以购买 1：可以申购
            ,supportsubscribe -- 认购开通标志 0：不可以购买 1：可以认购
            ,supportbuy -- 购买开通标志 0：不可以购买  1：可以购买
            ,nonstdredeemfee -- 非标准赎回费
            ,recommendflag -- 推荐标识
            ,uptdatetime -- 更新时间
            ,reserve1 -- 备用字段1
            ,reserve2 -- 备用字段2
            ,reserve3 -- 备用字段3
            ,reserve4 -- 备用字段4
            ,reserve5 -- 备用字段5
            ,reserve6 -- 备用字段6
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.mpcs_a92fund_op(
            paysys -- 服务方简称
            ,instid -- 接入商户号
            ,fundcode -- 基金代码
            ,fundfullname -- 基金全称
            ,fundname -- 基金简称
            ,fundtype -- 基金类型 0-其他类型 1-股票型 2-债券型 3-混合型 4-货币型 5-保本型 6-指数型 7-QDII 8-商品型 9-短期理财
            ,risklevel -- 风险等级 5-激进型,4-进取型,3-稳健型,2-谨慎型,1-保守型 0-未评级
            ,confirmpace -- 确认天数
            ,refundpace -- 赎回到账天数
            ,defaultdividendmethod -- 默认分红方式 0-红利资金再投 1-现金分红
            ,currency -- 币种 156-人民币
            ,salestat -- 销售状态  0:不代销（下架） 1:代销（上架）
            ,sharetype -- 收费类型A-前端收费  B-后端收费 C-C类收费
            ,supportperiodic -- 定投开通标志0:未开通  1:开通
            ,supportconvert -- 转换开通标志 0:未开通  1:开通
            ,managerrate -- 管理费率
            ,trusteerate -- 托管费率
            ,subscriberate -- 前端认购费率
            ,allotrate -- 前端申购费率
            ,redeemrate -- 赎回费率
            ,minindivisubscribeamount -- 个人首次认购最低金额
            ,minindiviappendsubscribeamount -- 个人追加认购最低金额
            ,maxindivisubscribeamount -- 个人最高认购金额
            ,minindiviallotamount -- 个人首次申购最低金额
            ,minindiviappendallotamount -- 个人追加申购最低金额
            ,maxindiviallotamount -- 个人最高申购金额
            ,minindiviperiodicamount -- 个人定投申购最低金额
            ,maxindiviperiodicamount -- 个人定投申购最高金额
            ,minindiviholdvol -- 个人持有最低份额
            ,minindiviredeemvol -- 个人赎回最低份额
            ,minindiviconvertvol -- 个人转换最低份额
            ,setupdate -- 成立日期
            ,fundcorp -- 管理人
            ,trustee -- 托管人
            ,fundmanager -- 基金经理
            ,reportdate -- 报告日期
            ,assetamount -- 资产规模
            ,assetvol -- 份额规模
            ,stockportfolio -- 十大重仓股
            ,industryportfolio -- 行业配置
            ,assetportfolio -- 资产配置
            ,uptdividendmethodflg -- 是否可修改分红方式
            ,salerate -- 销售服务费
            ,ecflag -- 是否签订电子合同 0 - 不需要 1 － 需要
            ,prodtype -- 产品类型1-开放型公募基金 2-封闭型公募基金 3-私募 4-专户 5-券商资管产品
            ,supportallot -- 申购开通标志 0：不可以购买 1：可以申购
            ,supportsubscribe -- 认购开通标志 0：不可以购买 1：可以认购
            ,supportbuy -- 购买开通标志 0：不可以购买  1：可以购买
            ,nonstdredeemfee -- 非标准赎回费
            ,recommendflag -- 推荐标识
            ,uptdatetime -- 更新时间
            ,reserve1 -- 备用字段1
            ,reserve2 -- 备用字段2
            ,reserve3 -- 备用字段3
            ,reserve4 -- 备用字段4
            ,reserve5 -- 备用字段5
            ,reserve6 -- 备用字段6
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.paysys -- 服务方简称
    ,o.instid -- 接入商户号
    ,o.fundcode -- 基金代码
    ,o.fundfullname -- 基金全称
    ,o.fundname -- 基金简称
    ,o.fundtype -- 基金类型 0-其他类型 1-股票型 2-债券型 3-混合型 4-货币型 5-保本型 6-指数型 7-QDII 8-商品型 9-短期理财
    ,o.risklevel -- 风险等级 5-激进型,4-进取型,3-稳健型,2-谨慎型,1-保守型 0-未评级
    ,o.confirmpace -- 确认天数
    ,o.refundpace -- 赎回到账天数
    ,o.defaultdividendmethod -- 默认分红方式 0-红利资金再投 1-现金分红
    ,o.currency -- 币种 156-人民币
    ,o.salestat -- 销售状态  0:不代销（下架） 1:代销（上架）
    ,o.sharetype -- 收费类型A-前端收费  B-后端收费 C-C类收费
    ,o.supportperiodic -- 定投开通标志0:未开通  1:开通
    ,o.supportconvert -- 转换开通标志 0:未开通  1:开通
    ,o.managerrate -- 管理费率
    ,o.trusteerate -- 托管费率
    ,o.subscriberate -- 前端认购费率
    ,o.allotrate -- 前端申购费率
    ,o.redeemrate -- 赎回费率
    ,o.minindivisubscribeamount -- 个人首次认购最低金额
    ,o.minindiviappendsubscribeamount -- 个人追加认购最低金额
    ,o.maxindivisubscribeamount -- 个人最高认购金额
    ,o.minindiviallotamount -- 个人首次申购最低金额
    ,o.minindiviappendallotamount -- 个人追加申购最低金额
    ,o.maxindiviallotamount -- 个人最高申购金额
    ,o.minindiviperiodicamount -- 个人定投申购最低金额
    ,o.maxindiviperiodicamount -- 个人定投申购最高金额
    ,o.minindiviholdvol -- 个人持有最低份额
    ,o.minindiviredeemvol -- 个人赎回最低份额
    ,o.minindiviconvertvol -- 个人转换最低份额
    ,o.setupdate -- 成立日期
    ,o.fundcorp -- 管理人
    ,o.trustee -- 托管人
    ,o.fundmanager -- 基金经理
    ,o.reportdate -- 报告日期
    ,o.assetamount -- 资产规模
    ,o.assetvol -- 份额规模
    ,o.stockportfolio -- 十大重仓股
    ,o.industryportfolio -- 行业配置
    ,o.assetportfolio -- 资产配置
    ,o.uptdividendmethodflg -- 是否可修改分红方式
    ,o.salerate -- 销售服务费
    ,o.ecflag -- 是否签订电子合同 0 - 不需要 1 － 需要
    ,o.prodtype -- 产品类型1-开放型公募基金 2-封闭型公募基金 3-私募 4-专户 5-券商资管产品
    ,o.supportallot -- 申购开通标志 0：不可以购买 1：可以申购
    ,o.supportsubscribe -- 认购开通标志 0：不可以购买 1：可以认购
    ,o.supportbuy -- 购买开通标志 0：不可以购买  1：可以购买
    ,o.nonstdredeemfee -- 非标准赎回费
    ,o.recommendflag -- 推荐标识
    ,o.uptdatetime -- 更新时间
    ,o.reserve1 -- 备用字段1
    ,o.reserve2 -- 备用字段2
    ,o.reserve3 -- 备用字段3
    ,o.reserve4 -- 备用字段4
    ,o.reserve5 -- 备用字段5
    ,o.reserve6 -- 备用字段6
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,case when n.start_dt is not null
          then 'I'
          when o.end_dt >= to_date('${batch_date}','yyyymmdd')
          then 'I'
          else o.id_mark
     end as id_mark  -- 增删标志 
    ,o.etl_timestamp -- ETL处理时间
from ${iol_schema}.mpcs_a92fund_bk o
    left join ${iol_schema}.mpcs_a92fund_op n
        on
            o.fundcode = n.fundcode
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.mpcs_a92fund_cl d
        on
            o.fundcode = d.fundcode
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.mpcs_a92fund;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('mpcs_a92fund') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.mpcs_a92fund drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.mpcs_a92fund add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.mpcs_a92fund exchange partition p_${batch_date} with table ${iol_schema}.mpcs_a92fund_cl;
alter table ${iol_schema}.mpcs_a92fund exchange partition p_20991231 with table ${iol_schema}.mpcs_a92fund_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.mpcs_a92fund to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.mpcs_a92fund_op purge;
drop table ${iol_schema}.mpcs_a92fund_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.mpcs_a92fund_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'mpcs_a92fund',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
