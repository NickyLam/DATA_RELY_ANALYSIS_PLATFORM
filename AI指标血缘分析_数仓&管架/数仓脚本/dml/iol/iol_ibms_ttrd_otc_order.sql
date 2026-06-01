/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_ibms_ttrd_otc_order
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
create table ${iol_schema}.ibms_ttrd_otc_order_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.ibms_ttrd_otc_order
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ibms_ttrd_otc_order_op purge;
drop table ${iol_schema}.ibms_ttrd_otc_order_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ibms_ttrd_otc_order_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ibms_ttrd_otc_order where 0=1;

create table ${iol_schema}.ibms_ttrd_otc_order_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ibms_ttrd_otc_order where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ibms_ttrd_otc_order_cl(
            orddate -- 委托日期
            ,ordtime -- 委托时间
            ,ordstatus -- 审批单状态 待提交审批 -1  待审批 0 审批中 1 审批完成 2  部分成交 5 成交 6 审批拒绝 8  撤销审批 9  审批失效 10  审批注销  11
            ,errcode -- 错误代码
            ,errinfo -- 错误信息
            ,total_amount -- 审批额度
            ,used_amount -- 实际占用额度
            ,remain_amount -- 剩余可用额度
            ,pa_xml -- 预授权xml
            ,beg_date -- 生效日期
            ,end_date -- 失效日期
            ,createdate -- 创建时间
            ,effectdays -- 审批有效期
            ,agent_inst_id -- 委托机构代码
            ,isinclimit -- 是否增量限额
            ,investtype -- 投资方式
            ,ord_user_id -- 审批号/交易号/指令号
            ,ord_user -- 审批人
            ,muti_trade_ref -- 是否关联比条交易1:否;2:是
            ,cancel_amount -- 注销额度
            ,order_type -- 审批单类型
            ,ord_id -- 审批单号
            ,remark -- 预授权xml
            ,min_effect_time -- 最小有效期
            ,max_effect_time -- 最大有效期
            ,direction -- 委托买卖方向
            ,i_code -- 委托资产代码
            ,a_type -- 委托资产类型
            ,m_type -- 委托资产市场类型
            ,wmps_unit_id -- 委托投组单元
            ,currency -- 币种
            ,limit_ytm -- 委托收益率
            ,limit_price -- 委托价格
            ,min_term -- 委托资产最小期限
            ,max_term -- 委托资产最大期限
            ,last_modifier_id -- 最后更新人
            ,last_modifier_time -- 最后更新时间
            ,spv_id -- 清算路径编号
            ,f_trader_roleid -- 一级交易员(角色)
            ,disp_amount -- 已分发额度
            ,undisp_amount -- 未分发额度
            ,abort_amount -- 终止额度
            ,accept_status -- 受理状态
            ,abort_status -- 终止状态
            ,exec_status -- 执行状态
            ,exec_amount -- 已执行额度
            ,unexec_amount -- 未执行额度
            ,asset_code -- 待起息资产
            ,i_name -- 委托资产名称
            ,bpm_status -- 流程状态
            ,bpm_type -- 流程类型1生成委托,2撤销委托
            ,cancel_ord_id -- 撤销流程ordid
            ,sysordid -- 交易序号
            ,remain_amount4confirm -- 审批单的剩余审批额度
            ,out_state -- 外部状态：0或null 成功；1 通知中；2 失败
            ,task_ordinal -- 审批中时 审批单在流程中的任务步骤序号
            ,cancelorback -- 撤销 0 退回 1（在审批单状态等于9时，标记是撤销还是退回）
            ,remain_amount4quote -- 剩余报价额度
            ,relation_ord_id -- 关联审批单号
            ,cm_attr_master -- 主从属性	0：无主从关系的交易 -1：存在主从关系的交易且当前交易为主交易 >0：存在主从关系并且当前交易为从交易（填写主交易的交易号）
            ,cm_attr_relation -- 关联属性 0：无关联属性 >0：具有相同的关联号的交易需要一起成交确认
            ,is_for_cfets -- 1：默认值，上下行关心的审批单 0：对上下行屏蔽的审批单
            ,match_mode -- P:（默认值）支持部分匹配 E: 只能精准匹配(协议回购的现券审批单)
            ,xcc_submit_date -- 
            ,xcc_completed_date -- 
            ,xcc_withdraw_user -- 注销人id
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ibms_ttrd_otc_order_op(
            orddate -- 委托日期
            ,ordtime -- 委托时间
            ,ordstatus -- 审批单状态 待提交审批 -1  待审批 0 审批中 1 审批完成 2  部分成交 5 成交 6 审批拒绝 8  撤销审批 9  审批失效 10  审批注销  11
            ,errcode -- 错误代码
            ,errinfo -- 错误信息
            ,total_amount -- 审批额度
            ,used_amount -- 实际占用额度
            ,remain_amount -- 剩余可用额度
            ,pa_xml -- 预授权xml
            ,beg_date -- 生效日期
            ,end_date -- 失效日期
            ,createdate -- 创建时间
            ,effectdays -- 审批有效期
            ,agent_inst_id -- 委托机构代码
            ,isinclimit -- 是否增量限额
            ,investtype -- 投资方式
            ,ord_user_id -- 审批号/交易号/指令号
            ,ord_user -- 审批人
            ,muti_trade_ref -- 是否关联比条交易1:否;2:是
            ,cancel_amount -- 注销额度
            ,order_type -- 审批单类型
            ,ord_id -- 审批单号
            ,remark -- 预授权xml
            ,min_effect_time -- 最小有效期
            ,max_effect_time -- 最大有效期
            ,direction -- 委托买卖方向
            ,i_code -- 委托资产代码
            ,a_type -- 委托资产类型
            ,m_type -- 委托资产市场类型
            ,wmps_unit_id -- 委托投组单元
            ,currency -- 币种
            ,limit_ytm -- 委托收益率
            ,limit_price -- 委托价格
            ,min_term -- 委托资产最小期限
            ,max_term -- 委托资产最大期限
            ,last_modifier_id -- 最后更新人
            ,last_modifier_time -- 最后更新时间
            ,spv_id -- 清算路径编号
            ,f_trader_roleid -- 一级交易员(角色)
            ,disp_amount -- 已分发额度
            ,undisp_amount -- 未分发额度
            ,abort_amount -- 终止额度
            ,accept_status -- 受理状态
            ,abort_status -- 终止状态
            ,exec_status -- 执行状态
            ,exec_amount -- 已执行额度
            ,unexec_amount -- 未执行额度
            ,asset_code -- 待起息资产
            ,i_name -- 委托资产名称
            ,bpm_status -- 流程状态
            ,bpm_type -- 流程类型1生成委托,2撤销委托
            ,cancel_ord_id -- 撤销流程ordid
            ,sysordid -- 交易序号
            ,remain_amount4confirm -- 审批单的剩余审批额度
            ,out_state -- 外部状态：0或null 成功；1 通知中；2 失败
            ,task_ordinal -- 审批中时 审批单在流程中的任务步骤序号
            ,cancelorback -- 撤销 0 退回 1（在审批单状态等于9时，标记是撤销还是退回）
            ,remain_amount4quote -- 剩余报价额度
            ,relation_ord_id -- 关联审批单号
            ,cm_attr_master -- 主从属性	0：无主从关系的交易 -1：存在主从关系的交易且当前交易为主交易 >0：存在主从关系并且当前交易为从交易（填写主交易的交易号）
            ,cm_attr_relation -- 关联属性 0：无关联属性 >0：具有相同的关联号的交易需要一起成交确认
            ,is_for_cfets -- 1：默认值，上下行关心的审批单 0：对上下行屏蔽的审批单
            ,match_mode -- P:（默认值）支持部分匹配 E: 只能精准匹配(协议回购的现券审批单)
            ,xcc_submit_date -- 
            ,xcc_completed_date -- 
            ,xcc_withdraw_user -- 注销人id
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.orddate, o.orddate) as orddate -- 委托日期
    ,nvl(n.ordtime, o.ordtime) as ordtime -- 委托时间
    ,nvl(n.ordstatus, o.ordstatus) as ordstatus -- 审批单状态 待提交审批 -1  待审批 0 审批中 1 审批完成 2  部分成交 5 成交 6 审批拒绝 8  撤销审批 9  审批失效 10  审批注销  11
    ,nvl(n.errcode, o.errcode) as errcode -- 错误代码
    ,nvl(n.errinfo, o.errinfo) as errinfo -- 错误信息
    ,nvl(n.total_amount, o.total_amount) as total_amount -- 审批额度
    ,nvl(n.used_amount, o.used_amount) as used_amount -- 实际占用额度
    ,nvl(n.remain_amount, o.remain_amount) as remain_amount -- 剩余可用额度
    ,nvl(n.pa_xml, o.pa_xml) as pa_xml -- 预授权xml
    ,nvl(n.beg_date, o.beg_date) as beg_date -- 生效日期
    ,nvl(n.end_date, o.end_date) as end_date -- 失效日期
    ,nvl(n.createdate, o.createdate) as createdate -- 创建时间
    ,nvl(n.effectdays, o.effectdays) as effectdays -- 审批有效期
    ,nvl(n.agent_inst_id, o.agent_inst_id) as agent_inst_id -- 委托机构代码
    ,nvl(n.isinclimit, o.isinclimit) as isinclimit -- 是否增量限额
    ,nvl(n.investtype, o.investtype) as investtype -- 投资方式
    ,nvl(n.ord_user_id, o.ord_user_id) as ord_user_id -- 审批号/交易号/指令号
    ,nvl(n.ord_user, o.ord_user) as ord_user -- 审批人
    ,nvl(n.muti_trade_ref, o.muti_trade_ref) as muti_trade_ref -- 是否关联比条交易1:否;2:是
    ,nvl(n.cancel_amount, o.cancel_amount) as cancel_amount -- 注销额度
    ,nvl(n.order_type, o.order_type) as order_type -- 审批单类型
    ,nvl(n.ord_id, o.ord_id) as ord_id -- 审批单号
    ,nvl(n.remark, o.remark) as remark -- 预授权xml
    ,nvl(n.min_effect_time, o.min_effect_time) as min_effect_time -- 最小有效期
    ,nvl(n.max_effect_time, o.max_effect_time) as max_effect_time -- 最大有效期
    ,nvl(n.direction, o.direction) as direction -- 委托买卖方向
    ,nvl(n.i_code, o.i_code) as i_code -- 委托资产代码
    ,nvl(n.a_type, o.a_type) as a_type -- 委托资产类型
    ,nvl(n.m_type, o.m_type) as m_type -- 委托资产市场类型
    ,nvl(n.wmps_unit_id, o.wmps_unit_id) as wmps_unit_id -- 委托投组单元
    ,nvl(n.currency, o.currency) as currency -- 币种
    ,nvl(n.limit_ytm, o.limit_ytm) as limit_ytm -- 委托收益率
    ,nvl(n.limit_price, o.limit_price) as limit_price -- 委托价格
    ,nvl(n.min_term, o.min_term) as min_term -- 委托资产最小期限
    ,nvl(n.max_term, o.max_term) as max_term -- 委托资产最大期限
    ,nvl(n.last_modifier_id, o.last_modifier_id) as last_modifier_id -- 最后更新人
    ,nvl(n.last_modifier_time, o.last_modifier_time) as last_modifier_time -- 最后更新时间
    ,nvl(n.spv_id, o.spv_id) as spv_id -- 清算路径编号
    ,nvl(n.f_trader_roleid, o.f_trader_roleid) as f_trader_roleid -- 一级交易员(角色)
    ,nvl(n.disp_amount, o.disp_amount) as disp_amount -- 已分发额度
    ,nvl(n.undisp_amount, o.undisp_amount) as undisp_amount -- 未分发额度
    ,nvl(n.abort_amount, o.abort_amount) as abort_amount -- 终止额度
    ,nvl(n.accept_status, o.accept_status) as accept_status -- 受理状态
    ,nvl(n.abort_status, o.abort_status) as abort_status -- 终止状态
    ,nvl(n.exec_status, o.exec_status) as exec_status -- 执行状态
    ,nvl(n.exec_amount, o.exec_amount) as exec_amount -- 已执行额度
    ,nvl(n.unexec_amount, o.unexec_amount) as unexec_amount -- 未执行额度
    ,nvl(n.asset_code, o.asset_code) as asset_code -- 待起息资产
    ,nvl(n.i_name, o.i_name) as i_name -- 委托资产名称
    ,nvl(n.bpm_status, o.bpm_status) as bpm_status -- 流程状态
    ,nvl(n.bpm_type, o.bpm_type) as bpm_type -- 流程类型1生成委托,2撤销委托
    ,nvl(n.cancel_ord_id, o.cancel_ord_id) as cancel_ord_id -- 撤销流程ordid
    ,nvl(n.sysordid, o.sysordid) as sysordid -- 交易序号
    ,nvl(n.remain_amount4confirm, o.remain_amount4confirm) as remain_amount4confirm -- 审批单的剩余审批额度
    ,nvl(n.out_state, o.out_state) as out_state -- 外部状态：0或null 成功；1 通知中；2 失败
    ,nvl(n.task_ordinal, o.task_ordinal) as task_ordinal -- 审批中时 审批单在流程中的任务步骤序号
    ,nvl(n.cancelorback, o.cancelorback) as cancelorback -- 撤销 0 退回 1（在审批单状态等于9时，标记是撤销还是退回）
    ,nvl(n.remain_amount4quote, o.remain_amount4quote) as remain_amount4quote -- 剩余报价额度
    ,nvl(n.relation_ord_id, o.relation_ord_id) as relation_ord_id -- 关联审批单号
    ,nvl(n.cm_attr_master, o.cm_attr_master) as cm_attr_master -- 主从属性	0：无主从关系的交易 -1：存在主从关系的交易且当前交易为主交易 >0：存在主从关系并且当前交易为从交易（填写主交易的交易号）
    ,nvl(n.cm_attr_relation, o.cm_attr_relation) as cm_attr_relation -- 关联属性 0：无关联属性 >0：具有相同的关联号的交易需要一起成交确认
    ,nvl(n.is_for_cfets, o.is_for_cfets) as is_for_cfets -- 1：默认值，上下行关心的审批单 0：对上下行屏蔽的审批单
    ,nvl(n.match_mode, o.match_mode) as match_mode -- P:（默认值）支持部分匹配 E: 只能精准匹配(协议回购的现券审批单)
    ,nvl(n.xcc_submit_date, o.xcc_submit_date) as xcc_submit_date -- 
    ,nvl(n.xcc_completed_date, o.xcc_completed_date) as xcc_completed_date -- 
    ,nvl(n.xcc_withdraw_user, o.xcc_withdraw_user) as xcc_withdraw_user -- 注销人id
    ,case when
            n.ord_id is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.ord_id is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.ord_id is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.ibms_ttrd_otc_order_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.ibms_ttrd_otc_order where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.ord_id = n.ord_id
where (
        o.ord_id is null
    )
    or (
        n.ord_id is null
    )
    or (
        o.orddate <> n.orddate
        or o.ordtime <> n.ordtime
        or o.ordstatus <> n.ordstatus
        or o.errcode <> n.errcode
        or o.errinfo <> n.errinfo
        or o.total_amount <> n.total_amount
        or o.used_amount <> n.used_amount
        or o.remain_amount <> n.remain_amount
        or o.pa_xml <> n.pa_xml
        or o.beg_date <> n.beg_date
        or o.end_date <> n.end_date
        or o.createdate <> n.createdate
        or o.effectdays <> n.effectdays
        or o.agent_inst_id <> n.agent_inst_id
        or o.isinclimit <> n.isinclimit
        or o.investtype <> n.investtype
        or o.ord_user_id <> n.ord_user_id
        or o.ord_user <> n.ord_user
        or o.muti_trade_ref <> n.muti_trade_ref
        or o.cancel_amount <> n.cancel_amount
        or o.order_type <> n.order_type
        or o.remark <> n.remark
        or o.min_effect_time <> n.min_effect_time
        or o.max_effect_time <> n.max_effect_time
        or o.direction <> n.direction
        or o.i_code <> n.i_code
        or o.a_type <> n.a_type
        or o.m_type <> n.m_type
        or o.wmps_unit_id <> n.wmps_unit_id
        or o.currency <> n.currency
        or o.limit_ytm <> n.limit_ytm
        or o.limit_price <> n.limit_price
        or o.min_term <> n.min_term
        or o.max_term <> n.max_term
        or o.last_modifier_id <> n.last_modifier_id
        or o.last_modifier_time <> n.last_modifier_time
        or o.spv_id <> n.spv_id
        or o.f_trader_roleid <> n.f_trader_roleid
        or o.disp_amount <> n.disp_amount
        or o.undisp_amount <> n.undisp_amount
        or o.abort_amount <> n.abort_amount
        or o.accept_status <> n.accept_status
        or o.abort_status <> n.abort_status
        or o.exec_status <> n.exec_status
        or o.exec_amount <> n.exec_amount
        or o.unexec_amount <> n.unexec_amount
        or o.asset_code <> n.asset_code
        or o.i_name <> n.i_name
        or o.bpm_status <> n.bpm_status
        or o.bpm_type <> n.bpm_type
        or o.cancel_ord_id <> n.cancel_ord_id
        or o.sysordid <> n.sysordid
        or o.remain_amount4confirm <> n.remain_amount4confirm
        or o.out_state <> n.out_state
        or o.task_ordinal <> n.task_ordinal
        or o.cancelorback <> n.cancelorback
        or o.remain_amount4quote <> n.remain_amount4quote
        or o.relation_ord_id <> n.relation_ord_id
        or o.cm_attr_master <> n.cm_attr_master
        or o.cm_attr_relation <> n.cm_attr_relation
        or o.is_for_cfets <> n.is_for_cfets
        or o.match_mode <> n.match_mode
        or o.xcc_submit_date <> n.xcc_submit_date
        or o.xcc_completed_date <> n.xcc_completed_date
        or o.xcc_withdraw_user <> n.xcc_withdraw_user
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ibms_ttrd_otc_order_cl(
            orddate -- 委托日期
            ,ordtime -- 委托时间
            ,ordstatus -- 审批单状态 待提交审批 -1  待审批 0 审批中 1 审批完成 2  部分成交 5 成交 6 审批拒绝 8  撤销审批 9  审批失效 10  审批注销  11
            ,errcode -- 错误代码
            ,errinfo -- 错误信息
            ,total_amount -- 审批额度
            ,used_amount -- 实际占用额度
            ,remain_amount -- 剩余可用额度
            ,pa_xml -- 预授权xml
            ,beg_date -- 生效日期
            ,end_date -- 失效日期
            ,createdate -- 创建时间
            ,effectdays -- 审批有效期
            ,agent_inst_id -- 委托机构代码
            ,isinclimit -- 是否增量限额
            ,investtype -- 投资方式
            ,ord_user_id -- 审批号/交易号/指令号
            ,ord_user -- 审批人
            ,muti_trade_ref -- 是否关联比条交易1:否;2:是
            ,cancel_amount -- 注销额度
            ,order_type -- 审批单类型
            ,ord_id -- 审批单号
            ,remark -- 预授权xml
            ,min_effect_time -- 最小有效期
            ,max_effect_time -- 最大有效期
            ,direction -- 委托买卖方向
            ,i_code -- 委托资产代码
            ,a_type -- 委托资产类型
            ,m_type -- 委托资产市场类型
            ,wmps_unit_id -- 委托投组单元
            ,currency -- 币种
            ,limit_ytm -- 委托收益率
            ,limit_price -- 委托价格
            ,min_term -- 委托资产最小期限
            ,max_term -- 委托资产最大期限
            ,last_modifier_id -- 最后更新人
            ,last_modifier_time -- 最后更新时间
            ,spv_id -- 清算路径编号
            ,f_trader_roleid -- 一级交易员(角色)
            ,disp_amount -- 已分发额度
            ,undisp_amount -- 未分发额度
            ,abort_amount -- 终止额度
            ,accept_status -- 受理状态
            ,abort_status -- 终止状态
            ,exec_status -- 执行状态
            ,exec_amount -- 已执行额度
            ,unexec_amount -- 未执行额度
            ,asset_code -- 待起息资产
            ,i_name -- 委托资产名称
            ,bpm_status -- 流程状态
            ,bpm_type -- 流程类型1生成委托,2撤销委托
            ,cancel_ord_id -- 撤销流程ordid
            ,sysordid -- 交易序号
            ,remain_amount4confirm -- 审批单的剩余审批额度
            ,out_state -- 外部状态：0或null 成功；1 通知中；2 失败
            ,task_ordinal -- 审批中时 审批单在流程中的任务步骤序号
            ,cancelorback -- 撤销 0 退回 1（在审批单状态等于9时，标记是撤销还是退回）
            ,remain_amount4quote -- 剩余报价额度
            ,relation_ord_id -- 关联审批单号
            ,cm_attr_master -- 主从属性	0：无主从关系的交易 -1：存在主从关系的交易且当前交易为主交易 >0：存在主从关系并且当前交易为从交易（填写主交易的交易号）
            ,cm_attr_relation -- 关联属性 0：无关联属性 >0：具有相同的关联号的交易需要一起成交确认
            ,is_for_cfets -- 1：默认值，上下行关心的审批单 0：对上下行屏蔽的审批单
            ,match_mode -- P:（默认值）支持部分匹配 E: 只能精准匹配(协议回购的现券审批单)
            ,xcc_submit_date -- 
            ,xcc_completed_date -- 
            ,xcc_withdraw_user -- 注销人id
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ibms_ttrd_otc_order_op(
            orddate -- 委托日期
            ,ordtime -- 委托时间
            ,ordstatus -- 审批单状态 待提交审批 -1  待审批 0 审批中 1 审批完成 2  部分成交 5 成交 6 审批拒绝 8  撤销审批 9  审批失效 10  审批注销  11
            ,errcode -- 错误代码
            ,errinfo -- 错误信息
            ,total_amount -- 审批额度
            ,used_amount -- 实际占用额度
            ,remain_amount -- 剩余可用额度
            ,pa_xml -- 预授权xml
            ,beg_date -- 生效日期
            ,end_date -- 失效日期
            ,createdate -- 创建时间
            ,effectdays -- 审批有效期
            ,agent_inst_id -- 委托机构代码
            ,isinclimit -- 是否增量限额
            ,investtype -- 投资方式
            ,ord_user_id -- 审批号/交易号/指令号
            ,ord_user -- 审批人
            ,muti_trade_ref -- 是否关联比条交易1:否;2:是
            ,cancel_amount -- 注销额度
            ,order_type -- 审批单类型
            ,ord_id -- 审批单号
            ,remark -- 预授权xml
            ,min_effect_time -- 最小有效期
            ,max_effect_time -- 最大有效期
            ,direction -- 委托买卖方向
            ,i_code -- 委托资产代码
            ,a_type -- 委托资产类型
            ,m_type -- 委托资产市场类型
            ,wmps_unit_id -- 委托投组单元
            ,currency -- 币种
            ,limit_ytm -- 委托收益率
            ,limit_price -- 委托价格
            ,min_term -- 委托资产最小期限
            ,max_term -- 委托资产最大期限
            ,last_modifier_id -- 最后更新人
            ,last_modifier_time -- 最后更新时间
            ,spv_id -- 清算路径编号
            ,f_trader_roleid -- 一级交易员(角色)
            ,disp_amount -- 已分发额度
            ,undisp_amount -- 未分发额度
            ,abort_amount -- 终止额度
            ,accept_status -- 受理状态
            ,abort_status -- 终止状态
            ,exec_status -- 执行状态
            ,exec_amount -- 已执行额度
            ,unexec_amount -- 未执行额度
            ,asset_code -- 待起息资产
            ,i_name -- 委托资产名称
            ,bpm_status -- 流程状态
            ,bpm_type -- 流程类型1生成委托,2撤销委托
            ,cancel_ord_id -- 撤销流程ordid
            ,sysordid -- 交易序号
            ,remain_amount4confirm -- 审批单的剩余审批额度
            ,out_state -- 外部状态：0或null 成功；1 通知中；2 失败
            ,task_ordinal -- 审批中时 审批单在流程中的任务步骤序号
            ,cancelorback -- 撤销 0 退回 1（在审批单状态等于9时，标记是撤销还是退回）
            ,remain_amount4quote -- 剩余报价额度
            ,relation_ord_id -- 关联审批单号
            ,cm_attr_master -- 主从属性	0：无主从关系的交易 -1：存在主从关系的交易且当前交易为主交易 >0：存在主从关系并且当前交易为从交易（填写主交易的交易号）
            ,cm_attr_relation -- 关联属性 0：无关联属性 >0：具有相同的关联号的交易需要一起成交确认
            ,is_for_cfets -- 1：默认值，上下行关心的审批单 0：对上下行屏蔽的审批单
            ,match_mode -- P:（默认值）支持部分匹配 E: 只能精准匹配(协议回购的现券审批单)
            ,xcc_submit_date -- 
            ,xcc_completed_date -- 
            ,xcc_withdraw_user -- 注销人id
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.orddate -- 委托日期
    ,o.ordtime -- 委托时间
    ,o.ordstatus -- 审批单状态 待提交审批 -1  待审批 0 审批中 1 审批完成 2  部分成交 5 成交 6 审批拒绝 8  撤销审批 9  审批失效 10  审批注销  11
    ,o.errcode -- 错误代码
    ,o.errinfo -- 错误信息
    ,o.total_amount -- 审批额度
    ,o.used_amount -- 实际占用额度
    ,o.remain_amount -- 剩余可用额度
    ,o.pa_xml -- 预授权xml
    ,o.beg_date -- 生效日期
    ,o.end_date -- 失效日期
    ,o.createdate -- 创建时间
    ,o.effectdays -- 审批有效期
    ,o.agent_inst_id -- 委托机构代码
    ,o.isinclimit -- 是否增量限额
    ,o.investtype -- 投资方式
    ,o.ord_user_id -- 审批号/交易号/指令号
    ,o.ord_user -- 审批人
    ,o.muti_trade_ref -- 是否关联比条交易1:否;2:是
    ,o.cancel_amount -- 注销额度
    ,o.order_type -- 审批单类型
    ,o.ord_id -- 审批单号
    ,o.remark -- 预授权xml
    ,o.min_effect_time -- 最小有效期
    ,o.max_effect_time -- 最大有效期
    ,o.direction -- 委托买卖方向
    ,o.i_code -- 委托资产代码
    ,o.a_type -- 委托资产类型
    ,o.m_type -- 委托资产市场类型
    ,o.wmps_unit_id -- 委托投组单元
    ,o.currency -- 币种
    ,o.limit_ytm -- 委托收益率
    ,o.limit_price -- 委托价格
    ,o.min_term -- 委托资产最小期限
    ,o.max_term -- 委托资产最大期限
    ,o.last_modifier_id -- 最后更新人
    ,o.last_modifier_time -- 最后更新时间
    ,o.spv_id -- 清算路径编号
    ,o.f_trader_roleid -- 一级交易员(角色)
    ,o.disp_amount -- 已分发额度
    ,o.undisp_amount -- 未分发额度
    ,o.abort_amount -- 终止额度
    ,o.accept_status -- 受理状态
    ,o.abort_status -- 终止状态
    ,o.exec_status -- 执行状态
    ,o.exec_amount -- 已执行额度
    ,o.unexec_amount -- 未执行额度
    ,o.asset_code -- 待起息资产
    ,o.i_name -- 委托资产名称
    ,o.bpm_status -- 流程状态
    ,o.bpm_type -- 流程类型1生成委托,2撤销委托
    ,o.cancel_ord_id -- 撤销流程ordid
    ,o.sysordid -- 交易序号
    ,o.remain_amount4confirm -- 审批单的剩余审批额度
    ,o.out_state -- 外部状态：0或null 成功；1 通知中；2 失败
    ,o.task_ordinal -- 审批中时 审批单在流程中的任务步骤序号
    ,o.cancelorback -- 撤销 0 退回 1（在审批单状态等于9时，标记是撤销还是退回）
    ,o.remain_amount4quote -- 剩余报价额度
    ,o.relation_ord_id -- 关联审批单号
    ,o.cm_attr_master -- 主从属性	0：无主从关系的交易 -1：存在主从关系的交易且当前交易为主交易 >0：存在主从关系并且当前交易为从交易（填写主交易的交易号）
    ,o.cm_attr_relation -- 关联属性 0：无关联属性 >0：具有相同的关联号的交易需要一起成交确认
    ,o.is_for_cfets -- 1：默认值，上下行关心的审批单 0：对上下行屏蔽的审批单
    ,o.match_mode -- P:（默认值）支持部分匹配 E: 只能精准匹配(协议回购的现券审批单)
    ,o.xcc_submit_date -- 
    ,o.xcc_completed_date -- 
    ,o.xcc_withdraw_user -- 注销人id
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
from ${iol_schema}.ibms_ttrd_otc_order_bk o
    left join ${iol_schema}.ibms_ttrd_otc_order_op n
        on
            o.ord_id = n.ord_id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.ibms_ttrd_otc_order_cl d
        on
            o.ord_id = d.ord_id
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.ibms_ttrd_otc_order;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('ibms_ttrd_otc_order') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.ibms_ttrd_otc_order drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.ibms_ttrd_otc_order add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.ibms_ttrd_otc_order exchange partition p_${batch_date} with table ${iol_schema}.ibms_ttrd_otc_order_cl;
alter table ${iol_schema}.ibms_ttrd_otc_order exchange partition p_20991231 with table ${iol_schema}.ibms_ttrd_otc_order_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.ibms_ttrd_otc_order to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ibms_ttrd_otc_order_op purge;
drop table ${iol_schema}.ibms_ttrd_otc_order_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.ibms_ttrd_otc_order_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'ibms_ttrd_otc_order',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
