/*
Purpose:    偏源模型层-增量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_mrms_tbl_cp_order_txn
CreateDate: 20180515
Logs:
    zjj 2018-05-15 新建脚本
*/

set timing on

-- 1.1 alter parallel
alter session force parallel query parallel 8;
alter session force parallel dml parallel 8;
-- alter session force parallel ddl parallel 8;

-- 2.1 create backup table
-- if backup table is exists, mean script if failed on last time
whenever sqlerror continue none ;
create table ${iol_schema}.mrms_tbl_cp_order_txn_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.mrms_tbl_cp_order_txn
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.mrms_tbl_cp_order_txn_op purge;
drop table ${iol_schema}.mrms_tbl_cp_order_txn_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.mrms_tbl_cp_order_txn_op nologging
compress ${option_switch} for query high
as select * from ${iol_schema}.mrms_tbl_cp_order_txn where 0=1;

create table ${iol_schema}.mrms_tbl_cp_order_txn_cl nologging
compress ${option_switch} for query high
as select * from ${iol_schema}.mrms_tbl_cp_order_txn where 0=1;

-- 3.1 get new, alter data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${iol_schema}.mrms_tbl_cp_order_txn_op(
        key_rsp -- 唯一流水号
        ,inst_date -- 交易日期
        ,inst_time -- 交易时间
        ,msg_src_id -- 原系统ID
        ,msg_dest_id -- 目标系统ID
        ,txn_num -- 交易码：1301：消费 、 1302：交易状态查询 1401：代理商对账文件下载 5301：退款、 3301：撤销、 3302：订单关闭 7301：商户入驻 7302：商户产品开通 7303：商户信息修改 7304：商户产品修改 7305：子商户微信配置添加 7307:下游退汇重出 7308:下游退汇重出(单一) 7309:代理商资金转出                                                                   7310:存量商户迁移                                                                   1303：扫码支付 1304：条码支付 1305：APP支付 1306：公众号支付
        ,txn_channel -- 后端渠道类型：支付宝“ALIPAY”,微信支付“WXPAY”,银联二维码"UPPAY"
        ,pay_type -- 交易费率
        ,mcht_no -- 商户号
        ,mcht_name -- 商户名称
        ,channel_mcht_no -- 渠道商户号
        ,channel_mcht_name -- 渠道商户名称
        ,channel_sec_mcht_no -- 渠道子商户号
        ,channel_sec_mcht_name -- 渠道子商户名称
        ,channel_ssn -- 后端渠道流水号
        ,channel_date -- 后端渠道交易日期
        ,pay_rate -- 支付渠道费率
        ,buyerid -- 用户标示
        ,adddata1 -- 附加数据1
        ,adddata2 -- 附加数据2
        ,channel -- 费率通道
        ,out_order_id -- 外部订单号（商户）
        ,out_order_title -- 订单标题
        ,out_order_desc -- 订单描述
        ,auth_cd -- 授权码
        ,agent_cd -- 代理商编号
        ,goodstag -- 订单优惠标记
        ,wx_public -- 微信公众号
        ,notifyurl -- 外部回调地址
        ,settlecurrencycode -- 币种：默认值’人民币：156’
        ,trade_money -- 交易金额(包含：消费、退货、撤销)
        ,market_money -- 营销活动金额（单笔消费营销活动的金额）
        ,add_money -- 增加金额退货等处理的时候计算
        ,ogl_ord_id -- 退货/撤销 原订单流水号
        ,ogl_ord_date -- 退货/撤销 原订单交易日期
        ,txn_sta -- 交易状态 01：新建 02：支付成功 03：支付失败 04：交易超时 05：交易成功不可退货或撤销 06：已发送，正在处理中 07: 客户扣款成功但未入商户账 08: 退款正在处理中(微信退款已处理) 09：支付成功，未到货 10：支付成功，部分到货 11: 支付成功，全部到货 00：预下订单成功，待支付中 13：订单已关闭
        ,banktype -- 付款银行
        ,successdate -- 付款成功日期
        ,successtime -- 付款成功时间
        ,res_code -- 响应码 0000：交易成功0001：交易失败
        ,res_desc -- 响应码描述
        ,undo_refund_flag -- 撤销退货专用字段 0：正常    1：已退货    2：已撤销
        ,delay_flag -- 挂账标志：0.正常        1.进行挂账
        ,code_url -- 付款二维码/付款吗
        ,expiretime -- 订单有效时间
        ,pan -- 支付卡号(不支持大于19位的存折)
        ,term_type -- 终端类型 01:手机、02：电脑PC端、03：其它
        ,brh_id -- 收单分行
        ,limitpay -- 借贷标识
        ,card_type -- 卡类型
        ,mq_state -- MQ发送状态
        ,notice_thread_id -- 发送线程ID
        ,out_mcht_no -- 外部商户号
        ,pay_channel -- 支付渠道
        ,transaction_id -- 
        ,idc_flag -- 网联idc标识
        ,gateway -- 网关
        ,voucher_num -- 付款凭证号
        ,start_dt -- 开始时间
        ,end_dt -- 结束时间
        ,id_mark -- 增删标志
        ,etl_timestamp -- ETL处理时间戳
    )
select
    n.key_rsp -- 唯一流水号
    ,n.inst_date -- 交易日期
    ,n.inst_time -- 交易时间
    ,n.msg_src_id -- 原系统ID
    ,n.msg_dest_id -- 目标系统ID
    ,n.txn_num -- 交易码：1301：消费 、 1302：交易状态查询 1401：代理商对账文件下载 5301：退款、 3301：撤销、 3302：订单关闭 7301：商户入驻 7302：商户产品开通 7303：商户信息修改 7304：商户产品修改 7305：子商户微信配置添加 7307:下游退汇重出 7308:下游退汇重出(单一) 7309:代理商资金转出                                                                   7310:存量商户迁移                                                                   1303：扫码支付 1304：条码支付 1305：APP支付 1306：公众号支付
    ,n.txn_channel -- 后端渠道类型：支付宝“ALIPAY”,微信支付“WXPAY”,银联二维码"UPPAY"
    ,n.pay_type -- 交易费率
    ,n.mcht_no -- 商户号
    ,n.mcht_name -- 商户名称
    ,n.channel_mcht_no -- 渠道商户号
    ,n.channel_mcht_name -- 渠道商户名称
    ,n.channel_sec_mcht_no -- 渠道子商户号
    ,n.channel_sec_mcht_name -- 渠道子商户名称
    ,n.channel_ssn -- 后端渠道流水号
    ,n.channel_date -- 后端渠道交易日期
    ,n.pay_rate -- 支付渠道费率
    ,n.buyerid -- 用户标示
    ,n.adddata1 -- 附加数据1
    ,n.adddata2 -- 附加数据2
    ,n.channel -- 费率通道
    ,n.out_order_id -- 外部订单号（商户）
    ,n.out_order_title -- 订单标题
    ,n.out_order_desc -- 订单描述
    ,n.auth_cd -- 授权码
    ,n.agent_cd -- 代理商编号
    ,n.goodstag -- 订单优惠标记
    ,n.wx_public -- 微信公众号
    ,n.notifyurl -- 外部回调地址
    ,n.settlecurrencycode -- 币种：默认值’人民币：156’
    ,n.trade_money -- 交易金额(包含：消费、退货、撤销)
    ,n.market_money -- 营销活动金额（单笔消费营销活动的金额）
    ,n.add_money -- 增加金额退货等处理的时候计算
    ,n.ogl_ord_id -- 退货/撤销 原订单流水号
    ,n.ogl_ord_date -- 退货/撤销 原订单交易日期
    ,n.txn_sta -- 交易状态 01：新建 02：支付成功 03：支付失败 04：交易超时 05：交易成功不可退货或撤销 06：已发送，正在处理中 07: 客户扣款成功但未入商户账 08: 退款正在处理中(微信退款已处理) 09：支付成功，未到货 10：支付成功，部分到货 11: 支付成功，全部到货 00：预下订单成功，待支付中 13：订单已关闭
    ,n.banktype -- 付款银行
    ,n.successdate -- 付款成功日期
    ,n.successtime -- 付款成功时间
    ,n.res_code -- 响应码 0000：交易成功0001：交易失败
    ,n.res_desc -- 响应码描述
    ,n.undo_refund_flag -- 撤销退货专用字段 0：正常    1：已退货    2：已撤销
    ,n.delay_flag -- 挂账标志：0.正常        1.进行挂账
    ,n.code_url -- 付款二维码/付款吗
    ,n.expiretime -- 订单有效时间
    ,n.pan -- 支付卡号(不支持大于19位的存折)
    ,n.term_type -- 终端类型 01:手机、02：电脑PC端、03：其它
    ,n.brh_id -- 收单分行
    ,n.limitpay -- 借贷标识
    ,n.card_type -- 卡类型
    ,n.mq_state -- MQ发送状态
    ,n.notice_thread_id -- 发送线程ID
    ,n.out_mcht_no -- 外部商户号
    ,n.pay_channel -- 支付渠道
    ,n.transaction_id -- 
    ,n.idc_flag -- 网联idc标识
    ,n.gateway -- 网关
    ,n.voucher_num -- 付款凭证号
    ,to_date('${batch_date}', 'yyyymmdd') as start_dt -- 开始时间
    ,to_date('20991231', 'yyyymmdd') as end_dt -- 结束时间
    ,'I' as id_mark  -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${iol_schema}.mrms_tbl_cp_order_txn_bk o
    right join (select * from ${itl_schema}.mrms_tbl_cp_order_txn where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.key_rsp = n.key_rsp
where (
        o.key_rsp is null
    )
    or (
        o.inst_date <> n.inst_date
        or o.inst_time <> n.inst_time
        or o.msg_src_id <> n.msg_src_id
        or o.msg_dest_id <> n.msg_dest_id
        or o.txn_num <> n.txn_num
        or o.txn_channel <> n.txn_channel
        or o.pay_type <> n.pay_type
        or o.mcht_no <> n.mcht_no
        or o.mcht_name <> n.mcht_name
        or o.channel_mcht_no <> n.channel_mcht_no
        or o.channel_mcht_name <> n.channel_mcht_name
        or o.channel_sec_mcht_no <> n.channel_sec_mcht_no
        or o.channel_sec_mcht_name <> n.channel_sec_mcht_name
        or o.channel_ssn <> n.channel_ssn
        or o.channel_date <> n.channel_date
        or o.pay_rate <> n.pay_rate
        or o.buyerid <> n.buyerid
        or o.adddata1 <> n.adddata1
        or o.adddata2 <> n.adddata2
        or o.channel <> n.channel
        or o.out_order_id <> n.out_order_id
        or o.out_order_title <> n.out_order_title
        or o.out_order_desc <> n.out_order_desc
        or o.auth_cd <> n.auth_cd
        or o.agent_cd <> n.agent_cd
        or o.goodstag <> n.goodstag
        or o.wx_public <> n.wx_public
        or o.notifyurl <> n.notifyurl
        or o.settlecurrencycode <> n.settlecurrencycode
        or o.trade_money <> n.trade_money
        or o.market_money <> n.market_money
        or o.add_money <> n.add_money
        or o.ogl_ord_id <> n.ogl_ord_id
        or o.ogl_ord_date <> n.ogl_ord_date
        or o.txn_sta <> n.txn_sta
        or o.banktype <> n.banktype
        or o.successdate <> n.successdate
        or o.successtime <> n.successtime
        or o.res_code <> n.res_code
        or o.res_desc <> n.res_desc
        or o.undo_refund_flag <> n.undo_refund_flag
        or o.delay_flag <> n.delay_flag
        or o.code_url <> n.code_url
        or o.expiretime <> n.expiretime
        or o.pan <> n.pan
        or o.term_type <> n.term_type
        or o.brh_id <> n.brh_id
        or o.limitpay <> n.limitpay
        or o.card_type <> n.card_type
        or o.mq_state <> n.mq_state
        or o.notice_thread_id <> n.notice_thread_id
        or o.out_mcht_no <> n.out_mcht_no
        or o.pay_channel <> n.pay_channel
        or o.transaction_id <> n.transaction_id
        or o.idc_flag <> n.idc_flag
        or o.gateway <> n.gateway
        or o.voucher_num <> n.voucher_num
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.mrms_tbl_cp_order_txn_cl(
            key_rsp -- 唯一流水号
        ,inst_date -- 交易日期
        ,inst_time -- 交易时间
        ,msg_src_id -- 原系统ID
        ,msg_dest_id -- 目标系统ID
        ,txn_num -- 交易码：1301：消费 、 1302：交易状态查询 1401：代理商对账文件下载 5301：退款、 3301：撤销、 3302：订单关闭 7301：商户入驻 7302：商户产品开通 7303：商户信息修改 7304：商户产品修改 7305：子商户微信配置添加 7307:下游退汇重出 7308:下游退汇重出(单一) 7309:代理商资金转出                                                                   7310:存量商户迁移                                                                   1303：扫码支付 1304：条码支付 1305：APP支付 1306：公众号支付
        ,txn_channel -- 后端渠道类型：支付宝“ALIPAY”,微信支付“WXPAY”,银联二维码"UPPAY"
        ,pay_type -- 交易费率
        ,mcht_no -- 商户号
        ,mcht_name -- 商户名称
        ,channel_mcht_no -- 渠道商户号
        ,channel_mcht_name -- 渠道商户名称
        ,channel_sec_mcht_no -- 渠道子商户号
        ,channel_sec_mcht_name -- 渠道子商户名称
        ,channel_ssn -- 后端渠道流水号
        ,channel_date -- 后端渠道交易日期
        ,pay_rate -- 支付渠道费率
        ,buyerid -- 用户标示
        ,adddata1 -- 附加数据1
        ,adddata2 -- 附加数据2
        ,channel -- 费率通道
        ,out_order_id -- 外部订单号（商户）
        ,out_order_title -- 订单标题
        ,out_order_desc -- 订单描述
        ,auth_cd -- 授权码
        ,agent_cd -- 代理商编号
        ,goodstag -- 订单优惠标记
        ,wx_public -- 微信公众号
        ,notifyurl -- 外部回调地址
        ,settlecurrencycode -- 币种：默认值’人民币：156’
        ,trade_money -- 交易金额(包含：消费、退货、撤销)
        ,market_money -- 营销活动金额（单笔消费营销活动的金额）
        ,add_money -- 增加金额退货等处理的时候计算
        ,ogl_ord_id -- 退货/撤销 原订单流水号
        ,ogl_ord_date -- 退货/撤销 原订单交易日期
        ,txn_sta -- 交易状态 01：新建 02：支付成功 03：支付失败 04：交易超时 05：交易成功不可退货或撤销 06：已发送，正在处理中 07: 客户扣款成功但未入商户账 08: 退款正在处理中(微信退款已处理) 09：支付成功，未到货 10：支付成功，部分到货 11: 支付成功，全部到货 00：预下订单成功，待支付中 13：订单已关闭
        ,banktype -- 付款银行
        ,successdate -- 付款成功日期
        ,successtime -- 付款成功时间
        ,res_code -- 响应码 0000：交易成功0001：交易失败
        ,res_desc -- 响应码描述
        ,undo_refund_flag -- 撤销退货专用字段 0：正常    1：已退货    2：已撤销
        ,delay_flag -- 挂账标志：0.正常        1.进行挂账
        ,code_url -- 付款二维码/付款吗
        ,expiretime -- 订单有效时间
        ,pan -- 支付卡号(不支持大于19位的存折)
        ,term_type -- 终端类型 01:手机、02：电脑PC端、03：其它
        ,brh_id -- 收单分行
        ,limitpay -- 借贷标识
        ,card_type -- 卡类型
        ,mq_state -- MQ发送状态
        ,notice_thread_id -- 发送线程ID
        ,out_mcht_no -- 外部商户号
        ,pay_channel -- 支付渠道
        ,transaction_id -- 
        ,idc_flag -- 网联idc标识
        ,gateway -- 网关
        ,voucher_num -- 付款凭证号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.mrms_tbl_cp_order_txn_op(
            key_rsp -- 唯一流水号
        ,inst_date -- 交易日期
        ,inst_time -- 交易时间
        ,msg_src_id -- 原系统ID
        ,msg_dest_id -- 目标系统ID
        ,txn_num -- 交易码：1301：消费 、 1302：交易状态查询 1401：代理商对账文件下载 5301：退款、 3301：撤销、 3302：订单关闭 7301：商户入驻 7302：商户产品开通 7303：商户信息修改 7304：商户产品修改 7305：子商户微信配置添加 7307:下游退汇重出 7308:下游退汇重出(单一) 7309:代理商资金转出                                                                   7310:存量商户迁移                                                                   1303：扫码支付 1304：条码支付 1305：APP支付 1306：公众号支付
        ,txn_channel -- 后端渠道类型：支付宝“ALIPAY”,微信支付“WXPAY”,银联二维码"UPPAY"
        ,pay_type -- 交易费率
        ,mcht_no -- 商户号
        ,mcht_name -- 商户名称
        ,channel_mcht_no -- 渠道商户号
        ,channel_mcht_name -- 渠道商户名称
        ,channel_sec_mcht_no -- 渠道子商户号
        ,channel_sec_mcht_name -- 渠道子商户名称
        ,channel_ssn -- 后端渠道流水号
        ,channel_date -- 后端渠道交易日期
        ,pay_rate -- 支付渠道费率
        ,buyerid -- 用户标示
        ,adddata1 -- 附加数据1
        ,adddata2 -- 附加数据2
        ,channel -- 费率通道
        ,out_order_id -- 外部订单号（商户）
        ,out_order_title -- 订单标题
        ,out_order_desc -- 订单描述
        ,auth_cd -- 授权码
        ,agent_cd -- 代理商编号
        ,goodstag -- 订单优惠标记
        ,wx_public -- 微信公众号
        ,notifyurl -- 外部回调地址
        ,settlecurrencycode -- 币种：默认值’人民币：156’
        ,trade_money -- 交易金额(包含：消费、退货、撤销)
        ,market_money -- 营销活动金额（单笔消费营销活动的金额）
        ,add_money -- 增加金额退货等处理的时候计算
        ,ogl_ord_id -- 退货/撤销 原订单流水号
        ,ogl_ord_date -- 退货/撤销 原订单交易日期
        ,txn_sta -- 交易状态 01：新建 02：支付成功 03：支付失败 04：交易超时 05：交易成功不可退货或撤销 06：已发送，正在处理中 07: 客户扣款成功但未入商户账 08: 退款正在处理中(微信退款已处理) 09：支付成功，未到货 10：支付成功，部分到货 11: 支付成功，全部到货 00：预下订单成功，待支付中 13：订单已关闭
        ,banktype -- 付款银行
        ,successdate -- 付款成功日期
        ,successtime -- 付款成功时间
        ,res_code -- 响应码 0000：交易成功0001：交易失败
        ,res_desc -- 响应码描述
        ,undo_refund_flag -- 撤销退货专用字段 0：正常    1：已退货    2：已撤销
        ,delay_flag -- 挂账标志：0.正常        1.进行挂账
        ,code_url -- 付款二维码/付款吗
        ,expiretime -- 订单有效时间
        ,pan -- 支付卡号(不支持大于19位的存折)
        ,term_type -- 终端类型 01:手机、02：电脑PC端、03：其它
        ,brh_id -- 收单分行
        ,limitpay -- 借贷标识
        ,card_type -- 卡类型
        ,mq_state -- MQ发送状态
        ,notice_thread_id -- 发送线程ID
        ,out_mcht_no -- 外部商户号
        ,pay_channel -- 支付渠道
        ,transaction_id -- 
        ,idc_flag -- 网联idc标识
        ,gateway -- 网关
        ,voucher_num -- 付款凭证号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.key_rsp -- 唯一流水号
    ,o.inst_date -- 交易日期
    ,o.inst_time -- 交易时间
    ,o.msg_src_id -- 原系统ID
    ,o.msg_dest_id -- 目标系统ID
    ,o.txn_num -- 交易码：1301：消费 、 1302：交易状态查询 1401：代理商对账文件下载 5301：退款、 3301：撤销、 3302：订单关闭 7301：商户入驻 7302：商户产品开通 7303：商户信息修改 7304：商户产品修改 7305：子商户微信配置添加 7307:下游退汇重出 7308:下游退汇重出(单一) 7309:代理商资金转出                                                                   7310:存量商户迁移                                                                   1303：扫码支付 1304：条码支付 1305：APP支付 1306：公众号支付
    ,o.txn_channel -- 后端渠道类型：支付宝“ALIPAY”,微信支付“WXPAY”,银联二维码"UPPAY"
    ,o.pay_type -- 交易费率
    ,o.mcht_no -- 商户号
    ,o.mcht_name -- 商户名称
    ,o.channel_mcht_no -- 渠道商户号
    ,o.channel_mcht_name -- 渠道商户名称
    ,o.channel_sec_mcht_no -- 渠道子商户号
    ,o.channel_sec_mcht_name -- 渠道子商户名称
    ,o.channel_ssn -- 后端渠道流水号
    ,o.channel_date -- 后端渠道交易日期
    ,o.pay_rate -- 支付渠道费率
    ,o.buyerid -- 用户标示
    ,o.adddata1 -- 附加数据1
    ,o.adddata2 -- 附加数据2
    ,o.channel -- 费率通道
    ,o.out_order_id -- 外部订单号（商户）
    ,o.out_order_title -- 订单标题
    ,o.out_order_desc -- 订单描述
    ,o.auth_cd -- 授权码
    ,o.agent_cd -- 代理商编号
    ,o.goodstag -- 订单优惠标记
    ,o.wx_public -- 微信公众号
    ,o.notifyurl -- 外部回调地址
    ,o.settlecurrencycode -- 币种：默认值’人民币：156’
    ,o.trade_money -- 交易金额(包含：消费、退货、撤销)
    ,o.market_money -- 营销活动金额（单笔消费营销活动的金额）
    ,o.add_money -- 增加金额退货等处理的时候计算
    ,o.ogl_ord_id -- 退货/撤销 原订单流水号
    ,o.ogl_ord_date -- 退货/撤销 原订单交易日期
    ,o.txn_sta -- 交易状态 01：新建 02：支付成功 03：支付失败 04：交易超时 05：交易成功不可退货或撤销 06：已发送，正在处理中 07: 客户扣款成功但未入商户账 08: 退款正在处理中(微信退款已处理) 09：支付成功，未到货 10：支付成功，部分到货 11: 支付成功，全部到货 00：预下订单成功，待支付中 13：订单已关闭
    ,o.banktype -- 付款银行
    ,o.successdate -- 付款成功日期
    ,o.successtime -- 付款成功时间
    ,o.res_code -- 响应码 0000：交易成功0001：交易失败
    ,o.res_desc -- 响应码描述
    ,o.undo_refund_flag -- 撤销退货专用字段 0：正常    1：已退货    2：已撤销
    ,o.delay_flag -- 挂账标志：0.正常        1.进行挂账
    ,o.code_url -- 付款二维码/付款吗
    ,o.expiretime -- 订单有效时间
    ,o.pan -- 支付卡号(不支持大于19位的存折)
    ,o.term_type -- 终端类型 01:手机、02：电脑PC端、03：其它
    ,o.brh_id -- 收单分行
    ,o.limitpay -- 借贷标识
    ,o.card_type -- 卡类型
    ,o.mq_state -- MQ发送状态
    ,o.notice_thread_id -- 发送线程ID
    ,o.out_mcht_no -- 外部商户号
    ,o.pay_channel -- 支付渠道
    ,o.transaction_id -- 
    ,o.idc_flag -- 网联idc标识
    ,o.gateway -- 网关
    ,o.voucher_num -- 付款凭证号
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,case when n.start_dt is not null then 'I'
          when o.end_dt>=to_date('${batch_date}','yyyymmdd') then 'I'
          else o.id_mark
     end as id_mark  -- 增删标志
    ,o.etl_timestamp -- ETL处理时间
from ${iol_schema}.mrms_tbl_cp_order_txn_bk o
    left join ${iol_schema}.mrms_tbl_cp_order_txn_op n
        on
            o.key_rsp = n.key_rsp
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
where o.start_dt < to_date('${batch_date}','yyyymmdd')
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.mrms_tbl_cp_order_txn;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('mrms_tbl_cp_order_txn') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.mrms_tbl_cp_order_txn drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.mrms_tbl_cp_order_txn add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.mrms_tbl_cp_order_txn exchange partition p_${batch_date} with table ${iol_schema}.mrms_tbl_cp_order_txn_cl;
alter table ${iol_schema}.mrms_tbl_cp_order_txn exchange partition p_20991231 with table ${iol_schema}.mrms_tbl_cp_order_txn_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.mrms_tbl_cp_order_txn to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.mrms_tbl_cp_order_txn_op purge;
drop table ${iol_schema}.mrms_tbl_cp_order_txn_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.mrms_tbl_cp_order_txn_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'mrms_tbl_cp_order_txn',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
