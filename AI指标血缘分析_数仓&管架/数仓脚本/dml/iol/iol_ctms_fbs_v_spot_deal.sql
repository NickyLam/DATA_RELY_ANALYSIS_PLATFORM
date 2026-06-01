/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_ctms_fbs_v_spot_deal
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
create table ${iol_schema}.ctms_fbs_v_spot_deal_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.ctms_fbs_v_spot_deal
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ctms_fbs_v_spot_deal_op purge;
drop table ${iol_schema}.ctms_fbs_v_spot_deal_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ctms_fbs_v_spot_deal_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ctms_fbs_v_spot_deal where 0=1;

create table ${iol_schema}.ctms_fbs_v_spot_deal_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ctms_fbs_v_spot_deal where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ctms_fbs_v_spot_deal_cl(
            cus_number -- 机构的唯一标识号
            ,branch_number -- 分支机构的唯一标识号
            ,deal_sqno -- 投组交易流水号，交易的FMS内部唯一编号
            ,deal_date -- 交易日期和时间
            ,value_date -- 起息日
            ,crncy_pair_id -- 货币对的SRNO
            ,spot_rate -- 成交汇率
            ,child_rate -- 分行汇率
            ,cost_rate -- 成本汇率
            ,first_amnt -- 货币1交易金额
            ,second_amnt -- 货币2交易金额
            ,trade_purpose -- 交易目的 0：其他 1：自营交易 2：代客交易 3：内部交易 4：经纪交易
            ,business_date -- 系统交易日，交易录入时的系统日期和时间
            ,counter_party_id -- 交易对手编码
            ,counter_party_scname -- 交易对手中文简称
            ,split_type -- 交易拆分的类型
            ,update_time -- 记录修改日期
            ,deal_dir -- 交易方向 1买 -1 卖
            ,pdd_deal_sqno -- 原始交易流水号，交易的FMS内部唯一编号
            ,deal_status -- 成交单状态
            ,first_crncy -- 第一货币
            ,second_crncy -- 第二货币
            ,client_deal_sqno -- 业务成交编号，来源如下： 1. 手工可不输入。 2. 文件导入，必须包含业务成交编号，且必须唯一。 3. 外部接口导入交易中，必须包含成交编号，且必须唯一。 4. CSTP下载交易中的成交编号。
            ,trade_type -- 交易模式 ZZ：其它 A：匿名（对应TradeInstrument=3） B：双边（对应TradeInstrument=1） GB：黄金.询价模式（对应TradeInstrument=6）
            ,deal_source -- 交易来源 C：CSTP，CSTP下载交易 E：External API，银行接口下载交易 F：File，文件导入交易 M：Manual，手工录入交易
            ,deal_market -- 交易场所： 其它 CFETS R：（保留） E：（保留） B：银行 S：模拟交易 V：虚拟交易（多笔交易组合出来的）（2.0.0）
            ,settle_type -- 清算方式 0：不用清算 1：双边净额清算，即集中净额清算（询价） 2：双边全额清算 3：集中净额清算（竞价） 4：净额+全额（暂时不使用）
            ,deal_link_sqno -- 交易修改删除的序列关系。 1. 交易修改时，通过本字段，R交易关联到U交易，A交易关联到R交易。 2. 交易删除时，通过本字段，R交易关联到D交易。 3. 无修改删除时，本字段为NULL
            ,modify_date -- 更新日期
            ,portfolio_sqno -- 投组交易编号
            ,portfolio_id -- 投资组合ID
            ,portfolio_name -- 投资组合名称
            ,portfolio_type -- 投组类型： 交易 对冲  自营买卖 市场平盘
            ,portfolio_status -- 投资组合状态： A：新交易 U：交易被修改 D：CSTP下载交易或第三方接口下载交易根据规则自动分配入投组 R：反向交易，用来通知周边系统，自己的原交易被删除，并反向对冲原交易的头寸和损益 M：已到期交易，交易全部完成交割后，由A状态置为M状态 C：取消投组
            ,portfolio_link_sqno -- 投组交易链接编号
            ,clear_dep -- 清算机构 ZZ：其它； AA：上清所
            ,event_type -- NM 正常。DV 交割衍生,可拆分。SP 注销衍生,可拆分。BK 违约衍生,可拆分。RO 展期衍生,可拆分。RB 提前交割衍,可拆分。EX 期权行
            ,event_date -- 事件日期
            ,event_link_sqno -- 事件(违约，展期，提前交割)关联交易编号
            ,event_mask -- NM 正常。DV 交割衍生,可拆分。SP 注销衍生,可拆分。BK 违约衍生,可拆分。RO 展期衍生,可拆分。RB 提前交割衍,可拆分。EX 期权行
            ,link_deal_sqno -- 期权的投组交易编号（SQNO）
            ,confirm_indc -- 交易后确认标识
            ,dealer -- 交易员
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ctms_fbs_v_spot_deal_op(
            cus_number -- 机构的唯一标识号
            ,branch_number -- 分支机构的唯一标识号
            ,deal_sqno -- 投组交易流水号，交易的FMS内部唯一编号
            ,deal_date -- 交易日期和时间
            ,value_date -- 起息日
            ,crncy_pair_id -- 货币对的SRNO
            ,spot_rate -- 成交汇率
            ,child_rate -- 分行汇率
            ,cost_rate -- 成本汇率
            ,first_amnt -- 货币1交易金额
            ,second_amnt -- 货币2交易金额
            ,trade_purpose -- 交易目的 0：其他 1：自营交易 2：代客交易 3：内部交易 4：经纪交易
            ,business_date -- 系统交易日，交易录入时的系统日期和时间
            ,counter_party_id -- 交易对手编码
            ,counter_party_scname -- 交易对手中文简称
            ,split_type -- 交易拆分的类型
            ,update_time -- 记录修改日期
            ,deal_dir -- 交易方向 1买 -1 卖
            ,pdd_deal_sqno -- 原始交易流水号，交易的FMS内部唯一编号
            ,deal_status -- 成交单状态
            ,first_crncy -- 第一货币
            ,second_crncy -- 第二货币
            ,client_deal_sqno -- 业务成交编号，来源如下： 1. 手工可不输入。 2. 文件导入，必须包含业务成交编号，且必须唯一。 3. 外部接口导入交易中，必须包含成交编号，且必须唯一。 4. CSTP下载交易中的成交编号。
            ,trade_type -- 交易模式 ZZ：其它 A：匿名（对应TradeInstrument=3） B：双边（对应TradeInstrument=1） GB：黄金.询价模式（对应TradeInstrument=6）
            ,deal_source -- 交易来源 C：CSTP，CSTP下载交易 E：External API，银行接口下载交易 F：File，文件导入交易 M：Manual，手工录入交易
            ,deal_market -- 交易场所： 其它 CFETS R：（保留） E：（保留） B：银行 S：模拟交易 V：虚拟交易（多笔交易组合出来的）（2.0.0）
            ,settle_type -- 清算方式 0：不用清算 1：双边净额清算，即集中净额清算（询价） 2：双边全额清算 3：集中净额清算（竞价） 4：净额+全额（暂时不使用）
            ,deal_link_sqno -- 交易修改删除的序列关系。 1. 交易修改时，通过本字段，R交易关联到U交易，A交易关联到R交易。 2. 交易删除时，通过本字段，R交易关联到D交易。 3. 无修改删除时，本字段为NULL
            ,modify_date -- 更新日期
            ,portfolio_sqno -- 投组交易编号
            ,portfolio_id -- 投资组合ID
            ,portfolio_name -- 投资组合名称
            ,portfolio_type -- 投组类型： 交易 对冲  自营买卖 市场平盘
            ,portfolio_status -- 投资组合状态： A：新交易 U：交易被修改 D：CSTP下载交易或第三方接口下载交易根据规则自动分配入投组 R：反向交易，用来通知周边系统，自己的原交易被删除，并反向对冲原交易的头寸和损益 M：已到期交易，交易全部完成交割后，由A状态置为M状态 C：取消投组
            ,portfolio_link_sqno -- 投组交易链接编号
            ,clear_dep -- 清算机构 ZZ：其它； AA：上清所
            ,event_type -- NM 正常。DV 交割衍生,可拆分。SP 注销衍生,可拆分。BK 违约衍生,可拆分。RO 展期衍生,可拆分。RB 提前交割衍,可拆分。EX 期权行
            ,event_date -- 事件日期
            ,event_link_sqno -- 事件(违约，展期，提前交割)关联交易编号
            ,event_mask -- NM 正常。DV 交割衍生,可拆分。SP 注销衍生,可拆分。BK 违约衍生,可拆分。RO 展期衍生,可拆分。RB 提前交割衍,可拆分。EX 期权行
            ,link_deal_sqno -- 期权的投组交易编号（SQNO）
            ,confirm_indc -- 交易后确认标识
            ,dealer -- 交易员
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.cus_number, o.cus_number) as cus_number -- 机构的唯一标识号
    ,nvl(n.branch_number, o.branch_number) as branch_number -- 分支机构的唯一标识号
    ,nvl(n.deal_sqno, o.deal_sqno) as deal_sqno -- 投组交易流水号，交易的FMS内部唯一编号
    ,nvl(n.deal_date, o.deal_date) as deal_date -- 交易日期和时间
    ,nvl(n.value_date, o.value_date) as value_date -- 起息日
    ,nvl(n.crncy_pair_id, o.crncy_pair_id) as crncy_pair_id -- 货币对的SRNO
    ,nvl(n.spot_rate, o.spot_rate) as spot_rate -- 成交汇率
    ,nvl(n.child_rate, o.child_rate) as child_rate -- 分行汇率
    ,nvl(n.cost_rate, o.cost_rate) as cost_rate -- 成本汇率
    ,nvl(n.first_amnt, o.first_amnt) as first_amnt -- 货币1交易金额
    ,nvl(n.second_amnt, o.second_amnt) as second_amnt -- 货币2交易金额
    ,nvl(n.trade_purpose, o.trade_purpose) as trade_purpose -- 交易目的 0：其他 1：自营交易 2：代客交易 3：内部交易 4：经纪交易
    ,nvl(n.business_date, o.business_date) as business_date -- 系统交易日，交易录入时的系统日期和时间
    ,nvl(n.counter_party_id, o.counter_party_id) as counter_party_id -- 交易对手编码
    ,nvl(n.counter_party_scname, o.counter_party_scname) as counter_party_scname -- 交易对手中文简称
    ,nvl(n.split_type, o.split_type) as split_type -- 交易拆分的类型
    ,nvl(n.update_time, o.update_time) as update_time -- 记录修改日期
    ,nvl(n.deal_dir, o.deal_dir) as deal_dir -- 交易方向 1买 -1 卖
    ,nvl(n.pdd_deal_sqno, o.pdd_deal_sqno) as pdd_deal_sqno -- 原始交易流水号，交易的FMS内部唯一编号
    ,nvl(n.deal_status, o.deal_status) as deal_status -- 成交单状态
    ,nvl(n.first_crncy, o.first_crncy) as first_crncy -- 第一货币
    ,nvl(n.second_crncy, o.second_crncy) as second_crncy -- 第二货币
    ,nvl(n.client_deal_sqno, o.client_deal_sqno) as client_deal_sqno -- 业务成交编号，来源如下： 1. 手工可不输入。 2. 文件导入，必须包含业务成交编号，且必须唯一。 3. 外部接口导入交易中，必须包含成交编号，且必须唯一。 4. CSTP下载交易中的成交编号。
    ,nvl(n.trade_type, o.trade_type) as trade_type -- 交易模式 ZZ：其它 A：匿名（对应TradeInstrument=3） B：双边（对应TradeInstrument=1） GB：黄金.询价模式（对应TradeInstrument=6）
    ,nvl(n.deal_source, o.deal_source) as deal_source -- 交易来源 C：CSTP，CSTP下载交易 E：External API，银行接口下载交易 F：File，文件导入交易 M：Manual，手工录入交易
    ,nvl(n.deal_market, o.deal_market) as deal_market -- 交易场所： 其它 CFETS R：（保留） E：（保留） B：银行 S：模拟交易 V：虚拟交易（多笔交易组合出来的）（2.0.0）
    ,nvl(n.settle_type, o.settle_type) as settle_type -- 清算方式 0：不用清算 1：双边净额清算，即集中净额清算（询价） 2：双边全额清算 3：集中净额清算（竞价） 4：净额+全额（暂时不使用）
    ,nvl(n.deal_link_sqno, o.deal_link_sqno) as deal_link_sqno -- 交易修改删除的序列关系。 1. 交易修改时，通过本字段，R交易关联到U交易，A交易关联到R交易。 2. 交易删除时，通过本字段，R交易关联到D交易。 3. 无修改删除时，本字段为NULL
    ,nvl(n.modify_date, o.modify_date) as modify_date -- 更新日期
    ,nvl(n.portfolio_sqno, o.portfolio_sqno) as portfolio_sqno -- 投组交易编号
    ,nvl(n.portfolio_id, o.portfolio_id) as portfolio_id -- 投资组合ID
    ,nvl(n.portfolio_name, o.portfolio_name) as portfolio_name -- 投资组合名称
    ,nvl(n.portfolio_type, o.portfolio_type) as portfolio_type -- 投组类型： 交易 对冲  自营买卖 市场平盘
    ,nvl(n.portfolio_status, o.portfolio_status) as portfolio_status -- 投资组合状态： A：新交易 U：交易被修改 D：CSTP下载交易或第三方接口下载交易根据规则自动分配入投组 R：反向交易，用来通知周边系统，自己的原交易被删除，并反向对冲原交易的头寸和损益 M：已到期交易，交易全部完成交割后，由A状态置为M状态 C：取消投组
    ,nvl(n.portfolio_link_sqno, o.portfolio_link_sqno) as portfolio_link_sqno -- 投组交易链接编号
    ,nvl(n.clear_dep, o.clear_dep) as clear_dep -- 清算机构 ZZ：其它； AA：上清所
    ,nvl(n.event_type, o.event_type) as event_type -- NM 正常。DV 交割衍生,可拆分。SP 注销衍生,可拆分。BK 违约衍生,可拆分。RO 展期衍生,可拆分。RB 提前交割衍,可拆分。EX 期权行
    ,nvl(n.event_date, o.event_date) as event_date -- 事件日期
    ,nvl(n.event_link_sqno, o.event_link_sqno) as event_link_sqno -- 事件(违约，展期，提前交割)关联交易编号
    ,nvl(n.event_mask, o.event_mask) as event_mask -- NM 正常。DV 交割衍生,可拆分。SP 注销衍生,可拆分。BK 违约衍生,可拆分。RO 展期衍生,可拆分。RB 提前交割衍,可拆分。EX 期权行
    ,nvl(n.link_deal_sqno, o.link_deal_sqno) as link_deal_sqno -- 期权的投组交易编号（SQNO）
    ,nvl(n.confirm_indc, o.confirm_indc) as confirm_indc -- 交易后确认标识
    ,nvl(n.dealer, o.dealer) as dealer -- 交易员
    ,case when
            n.cus_number is null
            and n.branch_number is null
            and n.deal_sqno is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.cus_number is null
            and n.branch_number is null
            and n.deal_sqno is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.cus_number is null
            and n.branch_number is null
            and n.deal_sqno is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.ctms_fbs_v_spot_deal_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.ctms_fbs_v_spot_deal where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.cus_number = n.cus_number
            and o.branch_number = n.branch_number
            and o.deal_sqno = n.deal_sqno
where (
        o.cus_number is null
        and o.branch_number is null
        and o.deal_sqno is null
    )
    or (
        n.cus_number is null
        and n.branch_number is null
        and n.deal_sqno is null
    )
    or (
        o.deal_date <> n.deal_date
        or o.value_date <> n.value_date
        or o.crncy_pair_id <> n.crncy_pair_id
        or o.spot_rate <> n.spot_rate
        or o.child_rate <> n.child_rate
        or o.cost_rate <> n.cost_rate
        or o.first_amnt <> n.first_amnt
        or o.second_amnt <> n.second_amnt
        or o.trade_purpose <> n.trade_purpose
        or o.business_date <> n.business_date
        or o.counter_party_id <> n.counter_party_id
        or o.counter_party_scname <> n.counter_party_scname
        or o.split_type <> n.split_type
        or o.update_time <> n.update_time
        or o.deal_dir <> n.deal_dir
        or o.pdd_deal_sqno <> n.pdd_deal_sqno
        or o.deal_status <> n.deal_status
        or o.first_crncy <> n.first_crncy
        or o.second_crncy <> n.second_crncy
        or o.client_deal_sqno <> n.client_deal_sqno
        or o.trade_type <> n.trade_type
        or o.deal_source <> n.deal_source
        or o.deal_market <> n.deal_market
        or o.settle_type <> n.settle_type
        or o.deal_link_sqno <> n.deal_link_sqno
        or o.modify_date <> n.modify_date
        or o.portfolio_sqno <> n.portfolio_sqno
        or o.portfolio_id <> n.portfolio_id
        or o.portfolio_name <> n.portfolio_name
        or o.portfolio_type <> n.portfolio_type
        or o.portfolio_status <> n.portfolio_status
        or o.portfolio_link_sqno <> n.portfolio_link_sqno
        or o.clear_dep <> n.clear_dep
        or o.event_type <> n.event_type
        or o.event_date <> n.event_date
        or o.event_link_sqno <> n.event_link_sqno
        or o.event_mask <> n.event_mask
        or o.link_deal_sqno <> n.link_deal_sqno
        or o.confirm_indc <> n.confirm_indc
        or o.dealer <> n.dealer
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ctms_fbs_v_spot_deal_cl(
            cus_number -- 机构的唯一标识号
            ,branch_number -- 分支机构的唯一标识号
            ,deal_sqno -- 投组交易流水号，交易的FMS内部唯一编号
            ,deal_date -- 交易日期和时间
            ,value_date -- 起息日
            ,crncy_pair_id -- 货币对的SRNO
            ,spot_rate -- 成交汇率
            ,child_rate -- 分行汇率
            ,cost_rate -- 成本汇率
            ,first_amnt -- 货币1交易金额
            ,second_amnt -- 货币2交易金额
            ,trade_purpose -- 交易目的 0：其他 1：自营交易 2：代客交易 3：内部交易 4：经纪交易
            ,business_date -- 系统交易日，交易录入时的系统日期和时间
            ,counter_party_id -- 交易对手编码
            ,counter_party_scname -- 交易对手中文简称
            ,split_type -- 交易拆分的类型
            ,update_time -- 记录修改日期
            ,deal_dir -- 交易方向 1买 -1 卖
            ,pdd_deal_sqno -- 原始交易流水号，交易的FMS内部唯一编号
            ,deal_status -- 成交单状态
            ,first_crncy -- 第一货币
            ,second_crncy -- 第二货币
            ,client_deal_sqno -- 业务成交编号，来源如下： 1. 手工可不输入。 2. 文件导入，必须包含业务成交编号，且必须唯一。 3. 外部接口导入交易中，必须包含成交编号，且必须唯一。 4. CSTP下载交易中的成交编号。
            ,trade_type -- 交易模式 ZZ：其它 A：匿名（对应TradeInstrument=3） B：双边（对应TradeInstrument=1） GB：黄金.询价模式（对应TradeInstrument=6）
            ,deal_source -- 交易来源 C：CSTP，CSTP下载交易 E：External API，银行接口下载交易 F：File，文件导入交易 M：Manual，手工录入交易
            ,deal_market -- 交易场所： 其它 CFETS R：（保留） E：（保留） B：银行 S：模拟交易 V：虚拟交易（多笔交易组合出来的）（2.0.0）
            ,settle_type -- 清算方式 0：不用清算 1：双边净额清算，即集中净额清算（询价） 2：双边全额清算 3：集中净额清算（竞价） 4：净额+全额（暂时不使用）
            ,deal_link_sqno -- 交易修改删除的序列关系。 1. 交易修改时，通过本字段，R交易关联到U交易，A交易关联到R交易。 2. 交易删除时，通过本字段，R交易关联到D交易。 3. 无修改删除时，本字段为NULL
            ,modify_date -- 更新日期
            ,portfolio_sqno -- 投组交易编号
            ,portfolio_id -- 投资组合ID
            ,portfolio_name -- 投资组合名称
            ,portfolio_type -- 投组类型： 交易 对冲  自营买卖 市场平盘
            ,portfolio_status -- 投资组合状态： A：新交易 U：交易被修改 D：CSTP下载交易或第三方接口下载交易根据规则自动分配入投组 R：反向交易，用来通知周边系统，自己的原交易被删除，并反向对冲原交易的头寸和损益 M：已到期交易，交易全部完成交割后，由A状态置为M状态 C：取消投组
            ,portfolio_link_sqno -- 投组交易链接编号
            ,clear_dep -- 清算机构 ZZ：其它； AA：上清所
            ,event_type -- NM 正常。DV 交割衍生,可拆分。SP 注销衍生,可拆分。BK 违约衍生,可拆分。RO 展期衍生,可拆分。RB 提前交割衍,可拆分。EX 期权行
            ,event_date -- 事件日期
            ,event_link_sqno -- 事件(违约，展期，提前交割)关联交易编号
            ,event_mask -- NM 正常。DV 交割衍生,可拆分。SP 注销衍生,可拆分。BK 违约衍生,可拆分。RO 展期衍生,可拆分。RB 提前交割衍,可拆分。EX 期权行
            ,link_deal_sqno -- 期权的投组交易编号（SQNO）
            ,confirm_indc -- 交易后确认标识
            ,dealer -- 交易员
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ctms_fbs_v_spot_deal_op(
            cus_number -- 机构的唯一标识号
            ,branch_number -- 分支机构的唯一标识号
            ,deal_sqno -- 投组交易流水号，交易的FMS内部唯一编号
            ,deal_date -- 交易日期和时间
            ,value_date -- 起息日
            ,crncy_pair_id -- 货币对的SRNO
            ,spot_rate -- 成交汇率
            ,child_rate -- 分行汇率
            ,cost_rate -- 成本汇率
            ,first_amnt -- 货币1交易金额
            ,second_amnt -- 货币2交易金额
            ,trade_purpose -- 交易目的 0：其他 1：自营交易 2：代客交易 3：内部交易 4：经纪交易
            ,business_date -- 系统交易日，交易录入时的系统日期和时间
            ,counter_party_id -- 交易对手编码
            ,counter_party_scname -- 交易对手中文简称
            ,split_type -- 交易拆分的类型
            ,update_time -- 记录修改日期
            ,deal_dir -- 交易方向 1买 -1 卖
            ,pdd_deal_sqno -- 原始交易流水号，交易的FMS内部唯一编号
            ,deal_status -- 成交单状态
            ,first_crncy -- 第一货币
            ,second_crncy -- 第二货币
            ,client_deal_sqno -- 业务成交编号，来源如下： 1. 手工可不输入。 2. 文件导入，必须包含业务成交编号，且必须唯一。 3. 外部接口导入交易中，必须包含成交编号，且必须唯一。 4. CSTP下载交易中的成交编号。
            ,trade_type -- 交易模式 ZZ：其它 A：匿名（对应TradeInstrument=3） B：双边（对应TradeInstrument=1） GB：黄金.询价模式（对应TradeInstrument=6）
            ,deal_source -- 交易来源 C：CSTP，CSTP下载交易 E：External API，银行接口下载交易 F：File，文件导入交易 M：Manual，手工录入交易
            ,deal_market -- 交易场所： 其它 CFETS R：（保留） E：（保留） B：银行 S：模拟交易 V：虚拟交易（多笔交易组合出来的）（2.0.0）
            ,settle_type -- 清算方式 0：不用清算 1：双边净额清算，即集中净额清算（询价） 2：双边全额清算 3：集中净额清算（竞价） 4：净额+全额（暂时不使用）
            ,deal_link_sqno -- 交易修改删除的序列关系。 1. 交易修改时，通过本字段，R交易关联到U交易，A交易关联到R交易。 2. 交易删除时，通过本字段，R交易关联到D交易。 3. 无修改删除时，本字段为NULL
            ,modify_date -- 更新日期
            ,portfolio_sqno -- 投组交易编号
            ,portfolio_id -- 投资组合ID
            ,portfolio_name -- 投资组合名称
            ,portfolio_type -- 投组类型： 交易 对冲  自营买卖 市场平盘
            ,portfolio_status -- 投资组合状态： A：新交易 U：交易被修改 D：CSTP下载交易或第三方接口下载交易根据规则自动分配入投组 R：反向交易，用来通知周边系统，自己的原交易被删除，并反向对冲原交易的头寸和损益 M：已到期交易，交易全部完成交割后，由A状态置为M状态 C：取消投组
            ,portfolio_link_sqno -- 投组交易链接编号
            ,clear_dep -- 清算机构 ZZ：其它； AA：上清所
            ,event_type -- NM 正常。DV 交割衍生,可拆分。SP 注销衍生,可拆分。BK 违约衍生,可拆分。RO 展期衍生,可拆分。RB 提前交割衍,可拆分。EX 期权行
            ,event_date -- 事件日期
            ,event_link_sqno -- 事件(违约，展期，提前交割)关联交易编号
            ,event_mask -- NM 正常。DV 交割衍生,可拆分。SP 注销衍生,可拆分。BK 违约衍生,可拆分。RO 展期衍生,可拆分。RB 提前交割衍,可拆分。EX 期权行
            ,link_deal_sqno -- 期权的投组交易编号（SQNO）
            ,confirm_indc -- 交易后确认标识
            ,dealer -- 交易员
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.cus_number -- 机构的唯一标识号
    ,o.branch_number -- 分支机构的唯一标识号
    ,o.deal_sqno -- 投组交易流水号，交易的FMS内部唯一编号
    ,o.deal_date -- 交易日期和时间
    ,o.value_date -- 起息日
    ,o.crncy_pair_id -- 货币对的SRNO
    ,o.spot_rate -- 成交汇率
    ,o.child_rate -- 分行汇率
    ,o.cost_rate -- 成本汇率
    ,o.first_amnt -- 货币1交易金额
    ,o.second_amnt -- 货币2交易金额
    ,o.trade_purpose -- 交易目的 0：其他 1：自营交易 2：代客交易 3：内部交易 4：经纪交易
    ,o.business_date -- 系统交易日，交易录入时的系统日期和时间
    ,o.counter_party_id -- 交易对手编码
    ,o.counter_party_scname -- 交易对手中文简称
    ,o.split_type -- 交易拆分的类型
    ,o.update_time -- 记录修改日期
    ,o.deal_dir -- 交易方向 1买 -1 卖
    ,o.pdd_deal_sqno -- 原始交易流水号，交易的FMS内部唯一编号
    ,o.deal_status -- 成交单状态
    ,o.first_crncy -- 第一货币
    ,o.second_crncy -- 第二货币
    ,o.client_deal_sqno -- 业务成交编号，来源如下： 1. 手工可不输入。 2. 文件导入，必须包含业务成交编号，且必须唯一。 3. 外部接口导入交易中，必须包含成交编号，且必须唯一。 4. CSTP下载交易中的成交编号。
    ,o.trade_type -- 交易模式 ZZ：其它 A：匿名（对应TradeInstrument=3） B：双边（对应TradeInstrument=1） GB：黄金.询价模式（对应TradeInstrument=6）
    ,o.deal_source -- 交易来源 C：CSTP，CSTP下载交易 E：External API，银行接口下载交易 F：File，文件导入交易 M：Manual，手工录入交易
    ,o.deal_market -- 交易场所： 其它 CFETS R：（保留） E：（保留） B：银行 S：模拟交易 V：虚拟交易（多笔交易组合出来的）（2.0.0）
    ,o.settle_type -- 清算方式 0：不用清算 1：双边净额清算，即集中净额清算（询价） 2：双边全额清算 3：集中净额清算（竞价） 4：净额+全额（暂时不使用）
    ,o.deal_link_sqno -- 交易修改删除的序列关系。 1. 交易修改时，通过本字段，R交易关联到U交易，A交易关联到R交易。 2. 交易删除时，通过本字段，R交易关联到D交易。 3. 无修改删除时，本字段为NULL
    ,o.modify_date -- 更新日期
    ,o.portfolio_sqno -- 投组交易编号
    ,o.portfolio_id -- 投资组合ID
    ,o.portfolio_name -- 投资组合名称
    ,o.portfolio_type -- 投组类型： 交易 对冲  自营买卖 市场平盘
    ,o.portfolio_status -- 投资组合状态： A：新交易 U：交易被修改 D：CSTP下载交易或第三方接口下载交易根据规则自动分配入投组 R：反向交易，用来通知周边系统，自己的原交易被删除，并反向对冲原交易的头寸和损益 M：已到期交易，交易全部完成交割后，由A状态置为M状态 C：取消投组
    ,o.portfolio_link_sqno -- 投组交易链接编号
    ,o.clear_dep -- 清算机构 ZZ：其它； AA：上清所
    ,o.event_type -- NM 正常。DV 交割衍生,可拆分。SP 注销衍生,可拆分。BK 违约衍生,可拆分。RO 展期衍生,可拆分。RB 提前交割衍,可拆分。EX 期权行
    ,o.event_date -- 事件日期
    ,o.event_link_sqno -- 事件(违约，展期，提前交割)关联交易编号
    ,o.event_mask -- NM 正常。DV 交割衍生,可拆分。SP 注销衍生,可拆分。BK 违约衍生,可拆分。RO 展期衍生,可拆分。RB 提前交割衍,可拆分。EX 期权行
    ,o.link_deal_sqno -- 期权的投组交易编号（SQNO）
    ,o.confirm_indc -- 交易后确认标识
    ,o.dealer -- 交易员
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
from ${iol_schema}.ctms_fbs_v_spot_deal_bk o
    left join ${iol_schema}.ctms_fbs_v_spot_deal_op n
        on
            o.cus_number = n.cus_number
            and o.branch_number = n.branch_number
            and o.deal_sqno = n.deal_sqno
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.ctms_fbs_v_spot_deal_cl d
        on
            o.cus_number = d.cus_number
            and o.branch_number = d.branch_number
            and o.deal_sqno = d.deal_sqno
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.ctms_fbs_v_spot_deal;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('ctms_fbs_v_spot_deal') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.ctms_fbs_v_spot_deal drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.ctms_fbs_v_spot_deal add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.ctms_fbs_v_spot_deal exchange partition p_${batch_date} with table ${iol_schema}.ctms_fbs_v_spot_deal_cl;
alter table ${iol_schema}.ctms_fbs_v_spot_deal exchange partition p_20991231 with table ${iol_schema}.ctms_fbs_v_spot_deal_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.ctms_fbs_v_spot_deal to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ctms_fbs_v_spot_deal_op purge;
drop table ${iol_schema}.ctms_fbs_v_spot_deal_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.ctms_fbs_v_spot_deal_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'ctms_fbs_v_spot_deal',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
