/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ctms_fbs_v_spot_deal
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ctms_fbs_v_spot_deal
whenever sqlerror continue none;
drop table ${iol_schema}.ctms_fbs_v_spot_deal purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ctms_fbs_v_spot_deal(
    cus_number number(5,0) -- 机构的唯一标识号
    ,branch_number number(5,0) -- 分支机构的唯一标识号
    ,deal_sqno number(18,0) -- 投组交易流水号，交易的FMS内部唯一编号
    ,deal_date date -- 交易日期和时间
    ,value_date date -- 起息日
    ,crncy_pair_id number(8,0) -- 货币对的SRNO
    ,spot_rate number -- 成交汇率
    ,child_rate number -- 分行汇率
    ,cost_rate number -- 成本汇率
    ,first_amnt number -- 货币1交易金额
    ,second_amnt number -- 货币2交易金额
    ,trade_purpose number(2,0) -- 交易目的 0：其他 1：自营交易 2：代客交易 3：内部交易 4：经纪交易
    ,business_date date -- 系统交易日，交易录入时的系统日期和时间
    ,counter_party_id number(8,0) -- 交易对手编码
    ,counter_party_scname varchar2(384) -- 交易对手中文简称
    ,split_type number(2,0) -- 交易拆分的类型
    ,update_time timestamp -- 记录修改日期
    ,deal_dir number -- 交易方向 1买 -1 卖
    ,pdd_deal_sqno number(18,0) -- 原始交易流水号，交易的FMS内部唯一编号
    ,deal_status varchar2(3) -- 成交单状态
    ,first_crncy varchar2(5) -- 第一货币
    ,second_crncy varchar2(5) -- 第二货币
    ,client_deal_sqno varchar2(45) -- 业务成交编号，来源如下： 1. 手工可不输入。 2. 文件导入，必须包含业务成交编号，且必须唯一。 3. 外部接口导入交易中，必须包含成交编号，且必须唯一。 4. CSTP下载交易中的成交编号。
    ,trade_type varchar2(3) -- 交易模式 ZZ：其它 A：匿名（对应TradeInstrument=3） B：双边（对应TradeInstrument=1） GB：黄金.询价模式（对应TradeInstrument=6）
    ,deal_source varchar2(3) -- 交易来源 C：CSTP，CSTP下载交易 E：External API，银行接口下载交易 F：File，文件导入交易 M：Manual，手工录入交易
    ,deal_market varchar2(8) -- 交易场所： 其它 CFETS R：（保留） E：（保留） B：银行 S：模拟交易 V：虚拟交易（多笔交易组合出来的）（2.0.0）
    ,settle_type number(2,0) -- 清算方式 0：不用清算 1：双边净额清算，即集中净额清算（询价） 2：双边全额清算 3：集中净额清算（竞价） 4：净额+全额（暂时不使用）
    ,deal_link_sqno number -- 交易修改删除的序列关系。 1. 交易修改时，通过本字段，R交易关联到U交易，A交易关联到R交易。 2. 交易删除时，通过本字段，R交易关联到D交易。 3. 无修改删除时，本字段为NULL
    ,modify_date date -- 更新日期
    ,portfolio_sqno number(18,0) -- 投组交易编号
    ,portfolio_id number(8,0) -- 投资组合ID
    ,portfolio_name varchar2(383) -- 投资组合名称
    ,portfolio_type varchar2(60) -- 投组类型： 交易 对冲  自营买卖 市场平盘
    ,portfolio_status varchar2(3) -- 投资组合状态： A：新交易 U：交易被修改 D：CSTP下载交易或第三方接口下载交易根据规则自动分配入投组 R：反向交易，用来通知周边系统，自己的原交易被删除，并反向对冲原交易的头寸和损益 M：已到期交易，交易全部完成交割后，由A状态置为M状态 C：取消投组
    ,portfolio_link_sqno number(18,0) -- 投组交易链接编号
    ,clear_dep varchar2(15) -- 清算机构 ZZ：其它； AA：上清所
    ,event_type varchar2(3) -- NM 正常。DV 交割衍生,可拆分。SP 注销衍生,可拆分。BK 违约衍生,可拆分。RO 展期衍生,可拆分。RB 提前交割衍,可拆分。EX 期权行
    ,event_date date -- 事件日期
    ,event_link_sqno number(18,0) -- 事件(违约，展期，提前交割)关联交易编号
    ,event_mask varchar2(3) -- NM 正常。DV 交割衍生,可拆分。SP 注销衍生,可拆分。BK 违约衍生,可拆分。RO 展期衍生,可拆分。RB 提前交割衍,可拆分。EX 期权行
    ,link_deal_sqno number(18,0) -- 期权的投组交易编号（SQNO）
    ,confirm_indc varchar2(8) -- 交易后确认标识
    ,dealer varchar2(60) -- 交易员
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
grant select on ${iol_schema}.ctms_fbs_v_spot_deal to ${iml_schema};
grant select on ${iol_schema}.ctms_fbs_v_spot_deal to ${icl_schema};
grant select on ${iol_schema}.ctms_fbs_v_spot_deal to ${idl_schema};
grant select on ${iol_schema}.ctms_fbs_v_spot_deal to ${iel_schema};

-- comment
comment on table ${iol_schema}.ctms_fbs_v_spot_deal is '即期视图';
comment on column ${iol_schema}.ctms_fbs_v_spot_deal.cus_number is '机构的唯一标识号';
comment on column ${iol_schema}.ctms_fbs_v_spot_deal.branch_number is '分支机构的唯一标识号';
comment on column ${iol_schema}.ctms_fbs_v_spot_deal.deal_sqno is '投组交易流水号，交易的FMS内部唯一编号';
comment on column ${iol_schema}.ctms_fbs_v_spot_deal.deal_date is '交易日期和时间';
comment on column ${iol_schema}.ctms_fbs_v_spot_deal.value_date is '起息日';
comment on column ${iol_schema}.ctms_fbs_v_spot_deal.crncy_pair_id is '货币对的SRNO';
comment on column ${iol_schema}.ctms_fbs_v_spot_deal.spot_rate is '成交汇率';
comment on column ${iol_schema}.ctms_fbs_v_spot_deal.child_rate is '分行汇率';
comment on column ${iol_schema}.ctms_fbs_v_spot_deal.cost_rate is '成本汇率';
comment on column ${iol_schema}.ctms_fbs_v_spot_deal.first_amnt is '货币1交易金额';
comment on column ${iol_schema}.ctms_fbs_v_spot_deal.second_amnt is '货币2交易金额';
comment on column ${iol_schema}.ctms_fbs_v_spot_deal.trade_purpose is '交易目的 0：其他 1：自营交易 2：代客交易 3：内部交易 4：经纪交易';
comment on column ${iol_schema}.ctms_fbs_v_spot_deal.business_date is '系统交易日，交易录入时的系统日期和时间';
comment on column ${iol_schema}.ctms_fbs_v_spot_deal.counter_party_id is '交易对手编码';
comment on column ${iol_schema}.ctms_fbs_v_spot_deal.counter_party_scname is '交易对手中文简称';
comment on column ${iol_schema}.ctms_fbs_v_spot_deal.split_type is '交易拆分的类型';
comment on column ${iol_schema}.ctms_fbs_v_spot_deal.update_time is '记录修改日期';
comment on column ${iol_schema}.ctms_fbs_v_spot_deal.deal_dir is '交易方向 1买 -1 卖';
comment on column ${iol_schema}.ctms_fbs_v_spot_deal.pdd_deal_sqno is '原始交易流水号，交易的FMS内部唯一编号';
comment on column ${iol_schema}.ctms_fbs_v_spot_deal.deal_status is '成交单状态';
comment on column ${iol_schema}.ctms_fbs_v_spot_deal.first_crncy is '第一货币';
comment on column ${iol_schema}.ctms_fbs_v_spot_deal.second_crncy is '第二货币';
comment on column ${iol_schema}.ctms_fbs_v_spot_deal.client_deal_sqno is '业务成交编号，来源如下： 1. 手工可不输入。 2. 文件导入，必须包含业务成交编号，且必须唯一。 3. 外部接口导入交易中，必须包含成交编号，且必须唯一。 4. CSTP下载交易中的成交编号。';
comment on column ${iol_schema}.ctms_fbs_v_spot_deal.trade_type is '交易模式 ZZ：其它 A：匿名（对应TradeInstrument=3） B：双边（对应TradeInstrument=1） GB：黄金.询价模式（对应TradeInstrument=6）';
comment on column ${iol_schema}.ctms_fbs_v_spot_deal.deal_source is '交易来源 C：CSTP，CSTP下载交易 E：External API，银行接口下载交易 F：File，文件导入交易 M：Manual，手工录入交易';
comment on column ${iol_schema}.ctms_fbs_v_spot_deal.deal_market is '交易场所： 其它 CFETS R：（保留） E：（保留） B：银行 S：模拟交易 V：虚拟交易（多笔交易组合出来的）（2.0.0）';
comment on column ${iol_schema}.ctms_fbs_v_spot_deal.settle_type is '清算方式 0：不用清算 1：双边净额清算，即集中净额清算（询价） 2：双边全额清算 3：集中净额清算（竞价） 4：净额+全额（暂时不使用）';
comment on column ${iol_schema}.ctms_fbs_v_spot_deal.deal_link_sqno is '交易修改删除的序列关系。 1. 交易修改时，通过本字段，R交易关联到U交易，A交易关联到R交易。 2. 交易删除时，通过本字段，R交易关联到D交易。 3. 无修改删除时，本字段为NULL';
comment on column ${iol_schema}.ctms_fbs_v_spot_deal.modify_date is '更新日期';
comment on column ${iol_schema}.ctms_fbs_v_spot_deal.portfolio_sqno is '投组交易编号';
comment on column ${iol_schema}.ctms_fbs_v_spot_deal.portfolio_id is '投资组合ID';
comment on column ${iol_schema}.ctms_fbs_v_spot_deal.portfolio_name is '投资组合名称';
comment on column ${iol_schema}.ctms_fbs_v_spot_deal.portfolio_type is '投组类型： 交易 对冲  自营买卖 市场平盘';
comment on column ${iol_schema}.ctms_fbs_v_spot_deal.portfolio_status is '投资组合状态： A：新交易 U：交易被修改 D：CSTP下载交易或第三方接口下载交易根据规则自动分配入投组 R：反向交易，用来通知周边系统，自己的原交易被删除，并反向对冲原交易的头寸和损益 M：已到期交易，交易全部完成交割后，由A状态置为M状态 C：取消投组';
comment on column ${iol_schema}.ctms_fbs_v_spot_deal.portfolio_link_sqno is '投组交易链接编号';
comment on column ${iol_schema}.ctms_fbs_v_spot_deal.clear_dep is '清算机构 ZZ：其它； AA：上清所';
comment on column ${iol_schema}.ctms_fbs_v_spot_deal.event_type is 'NM 正常。DV 交割衍生,可拆分。SP 注销衍生,可拆分。BK 违约衍生,可拆分。RO 展期衍生,可拆分。RB 提前交割衍,可拆分。EX 期权行';
comment on column ${iol_schema}.ctms_fbs_v_spot_deal.event_date is '事件日期';
comment on column ${iol_schema}.ctms_fbs_v_spot_deal.event_link_sqno is '事件(违约，展期，提前交割)关联交易编号';
comment on column ${iol_schema}.ctms_fbs_v_spot_deal.event_mask is 'NM 正常。DV 交割衍生,可拆分。SP 注销衍生,可拆分。BK 违约衍生,可拆分。RO 展期衍生,可拆分。RB 提前交割衍,可拆分。EX 期权行';
comment on column ${iol_schema}.ctms_fbs_v_spot_deal.link_deal_sqno is '期权的投组交易编号（SQNO）';
comment on column ${iol_schema}.ctms_fbs_v_spot_deal.confirm_indc is '交易后确认标识';
comment on column ${iol_schema}.ctms_fbs_v_spot_deal.dealer is '交易员';
comment on column ${iol_schema}.ctms_fbs_v_spot_deal.start_dt is '开始时间';
comment on column ${iol_schema}.ctms_fbs_v_spot_deal.end_dt is '结束时间';
comment on column ${iol_schema}.ctms_fbs_v_spot_deal.id_mark is '增删标志';
comment on column ${iol_schema}.ctms_fbs_v_spot_deal.etl_timestamp is 'ETL处理时间戳';
