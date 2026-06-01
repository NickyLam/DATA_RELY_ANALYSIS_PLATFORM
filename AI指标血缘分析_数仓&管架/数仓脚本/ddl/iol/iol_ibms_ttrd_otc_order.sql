/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ibms_ttrd_otc_order
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ibms_ttrd_otc_order
whenever sqlerror continue none;
drop table ${iol_schema}.ibms_ttrd_otc_order purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ibms_ttrd_otc_order(
    orddate varchar2(15) -- 委托日期
    ,ordtime varchar2(30) -- 委托时间
    ,ordstatus number(22) -- 审批单状态  待提交审批 -1  待审批 0 审批中 1 审批完成 2  部分成交 5 成交 6 审批拒绝 8  撤销审批 9  审批失效 10  审批注销  11
    ,errcode number(22) -- 错误代码
    ,errinfo varchar2(1500) -- 错误信息
    ,total_amount number(31,4) -- 审批额度
    ,used_amount number(31,4) -- 实际占用额度
    ,remain_amount number(31,4) -- 剩余可用额度
    ,pa_xml varchar2(4000) -- 预授权xml
    ,beg_date varchar2(15) -- 生效日期
    ,end_date varchar2(15) -- 失效日期
    ,createdate varchar2(75) -- 创建时间
    ,effectdays number(22) -- 审批有效期
    ,agent_inst_id varchar2(30) -- 委托机构代码
    ,isinclimit number(22) -- 是否增量限额
    ,investtype varchar2(75) -- 投资方式
    ,ord_user_id varchar2(30) -- 审批号/交易号/指令号
    ,ord_user varchar2(150) -- 审批人
    ,muti_trade_ref number(22) -- 是否关联比条交易1:否;2:是
    ,cancel_amount number(31,4) -- 注销额度
    ,order_type number(22) -- 审批单类型
    ,ord_id varchar2(75) -- 审批单号
    ,remark varchar2(4000) -- 预授权xml
    ,min_effect_time varchar2(30) -- 最小有效期
    ,max_effect_time varchar2(30) -- 最大有效期
    ,direction varchar2(15) -- 委托买卖方向
    ,i_code varchar2(45) -- 委托资产代码
    ,a_type varchar2(30) -- 委托资产类型
    ,m_type varchar2(30) -- 委托资产市场类型
    ,wmps_unit_id number(16,0) -- 委托投组单元
    ,currency varchar2(15) -- 币种
    ,limit_ytm number(31,8) -- 委托收益率
    ,limit_price number(31,6) -- 委托价格
    ,min_term number(16,0) -- 委托资产最小期限
    ,max_term number(16,0) -- 委托资产最大期限
    ,last_modifier_id number(19,0) -- 最后更新人
    ,last_modifier_time number(19,0) -- 最后更新时间
    ,spv_id number(16,0) -- 清算路径编号
    ,f_trader_roleid number(11,0) -- 一级交易员(角色)
    ,disp_amount number(31,4) -- 已分发额度
    ,undisp_amount number(31,4) -- 未分发额度
    ,abort_amount number(31,4) -- 终止额度
    ,accept_status number(31,0) -- 受理状态
    ,abort_status number(31,0) -- 终止状态
    ,exec_status number(31,0) -- 执行状态
    ,exec_amount number(31,4) -- 已执行额度
    ,unexec_amount number(31,4) -- 未执行额度
    ,asset_code varchar2(75) -- 待起息资产
    ,i_name varchar2(300) -- 委托资产名称
    ,bpm_status number(16,0) -- 流程状态
    ,bpm_type number(16,0) -- 流程类型1生成委托,2撤销委托
    ,cancel_ord_id number(31,0) -- 撤销流程ordid
    ,sysordid number(16,0) -- 交易序号
    ,remain_amount4confirm number(31,4) -- 审批单的剩余审批额度
    ,out_state number(1,0) -- 外部状态：0或null 成功；1 通知中；2 失败
    ,task_ordinal number(5,0) -- 审批中时 审批单在流程中的任务步骤序号
    ,cancelorback varchar2(2) -- 撤销 0 退回 1（在审批单状态等于9时，标记是撤销还是退回）
    ,remain_amount4quote number(31,6) -- 剩余报价额度
    ,relation_ord_id varchar2(75) -- 关联审批单号
    ,cm_attr_master varchar2(75) -- 主从属性	0：无主从关系的交易 -1：存在主从关系的交易且当前交易为主交易 >0：存在主从关系并且当前交易为从交易（填写主交易的交易号）
    ,cm_attr_relation varchar2(75) -- 关联属性 0：无关联属性 >0：具有相同的关联号的交易需要一起成交确认
    ,is_for_cfets varchar2(2) -- 1：默认值，上下行关心的审批单 0：对上下行屏蔽的审批单
    ,match_mode varchar2(2) -- p:（默认值）支持部分匹配 e: 只能精准匹配(协议回购的现券审批单)
    ,xcc_submit_date varchar2(35) -- 
    ,xcc_completed_date varchar2(35) -- 
    ,xcc_withdraw_user varchar2(45) -- 注销人id
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
grant select on ${iol_schema}.ibms_ttrd_otc_order to ${iml_schema};
grant select on ${iol_schema}.ibms_ttrd_otc_order to ${icl_schema};
grant select on ${iol_schema}.ibms_ttrd_otc_order to ${idl_schema};
grant select on ${iol_schema}.ibms_ttrd_otc_order to ${iel_schema};

-- comment
comment on table ${iol_schema}.ibms_ttrd_otc_order is '审批单表';
comment on column ${iol_schema}.ibms_ttrd_otc_order.orddate is '委托日期';
comment on column ${iol_schema}.ibms_ttrd_otc_order.ordtime is '委托时间';
comment on column ${iol_schema}.ibms_ttrd_otc_order.ordstatus is '审批单状态  待提交审批 -1  待审批 0 审批中 1 审批完成 2  部分成交 5 成交 6 审批拒绝 8  撤销审批 9  审批失效 10  审批注销  11';
comment on column ${iol_schema}.ibms_ttrd_otc_order.errcode is '错误代码';
comment on column ${iol_schema}.ibms_ttrd_otc_order.errinfo is '错误信息';
comment on column ${iol_schema}.ibms_ttrd_otc_order.total_amount is '审批额度';
comment on column ${iol_schema}.ibms_ttrd_otc_order.used_amount is '实际占用额度';
comment on column ${iol_schema}.ibms_ttrd_otc_order.remain_amount is '剩余可用额度';
comment on column ${iol_schema}.ibms_ttrd_otc_order.pa_xml is '预授权xml';
comment on column ${iol_schema}.ibms_ttrd_otc_order.beg_date is '生效日期';
comment on column ${iol_schema}.ibms_ttrd_otc_order.end_date is '失效日期';
comment on column ${iol_schema}.ibms_ttrd_otc_order.createdate is '创建时间';
comment on column ${iol_schema}.ibms_ttrd_otc_order.effectdays is '审批有效期';
comment on column ${iol_schema}.ibms_ttrd_otc_order.agent_inst_id is '委托机构代码';
comment on column ${iol_schema}.ibms_ttrd_otc_order.isinclimit is '是否增量限额';
comment on column ${iol_schema}.ibms_ttrd_otc_order.investtype is '投资方式';
comment on column ${iol_schema}.ibms_ttrd_otc_order.ord_user_id is '审批号/交易号/指令号';
comment on column ${iol_schema}.ibms_ttrd_otc_order.ord_user is '审批人';
comment on column ${iol_schema}.ibms_ttrd_otc_order.muti_trade_ref is '是否关联比条交易1:否;2:是';
comment on column ${iol_schema}.ibms_ttrd_otc_order.cancel_amount is '注销额度';
comment on column ${iol_schema}.ibms_ttrd_otc_order.order_type is '审批单类型';
comment on column ${iol_schema}.ibms_ttrd_otc_order.ord_id is '审批单号';
comment on column ${iol_schema}.ibms_ttrd_otc_order.remark is '预授权xml';
comment on column ${iol_schema}.ibms_ttrd_otc_order.min_effect_time is '最小有效期';
comment on column ${iol_schema}.ibms_ttrd_otc_order.max_effect_time is '最大有效期';
comment on column ${iol_schema}.ibms_ttrd_otc_order.direction is '委托买卖方向';
comment on column ${iol_schema}.ibms_ttrd_otc_order.i_code is '委托资产代码';
comment on column ${iol_schema}.ibms_ttrd_otc_order.a_type is '委托资产类型';
comment on column ${iol_schema}.ibms_ttrd_otc_order.m_type is '委托资产市场类型';
comment on column ${iol_schema}.ibms_ttrd_otc_order.wmps_unit_id is '委托投组单元';
comment on column ${iol_schema}.ibms_ttrd_otc_order.currency is '币种';
comment on column ${iol_schema}.ibms_ttrd_otc_order.limit_ytm is '委托收益率';
comment on column ${iol_schema}.ibms_ttrd_otc_order.limit_price is '委托价格';
comment on column ${iol_schema}.ibms_ttrd_otc_order.min_term is '委托资产最小期限';
comment on column ${iol_schema}.ibms_ttrd_otc_order.max_term is '委托资产最大期限';
comment on column ${iol_schema}.ibms_ttrd_otc_order.last_modifier_id is '最后更新人';
comment on column ${iol_schema}.ibms_ttrd_otc_order.last_modifier_time is '最后更新时间';
comment on column ${iol_schema}.ibms_ttrd_otc_order.spv_id is '清算路径编号';
comment on column ${iol_schema}.ibms_ttrd_otc_order.f_trader_roleid is '一级交易员(角色)';
comment on column ${iol_schema}.ibms_ttrd_otc_order.disp_amount is '已分发额度';
comment on column ${iol_schema}.ibms_ttrd_otc_order.undisp_amount is '未分发额度';
comment on column ${iol_schema}.ibms_ttrd_otc_order.abort_amount is '终止额度';
comment on column ${iol_schema}.ibms_ttrd_otc_order.accept_status is '受理状态';
comment on column ${iol_schema}.ibms_ttrd_otc_order.abort_status is '终止状态';
comment on column ${iol_schema}.ibms_ttrd_otc_order.exec_status is '执行状态';
comment on column ${iol_schema}.ibms_ttrd_otc_order.exec_amount is '已执行额度';
comment on column ${iol_schema}.ibms_ttrd_otc_order.unexec_amount is '未执行额度';
comment on column ${iol_schema}.ibms_ttrd_otc_order.asset_code is '待起息资产';
comment on column ${iol_schema}.ibms_ttrd_otc_order.i_name is '委托资产名称';
comment on column ${iol_schema}.ibms_ttrd_otc_order.bpm_status is '流程状态';
comment on column ${iol_schema}.ibms_ttrd_otc_order.bpm_type is '流程类型1生成委托,2撤销委托';
comment on column ${iol_schema}.ibms_ttrd_otc_order.cancel_ord_id is '撤销流程ordid';
comment on column ${iol_schema}.ibms_ttrd_otc_order.sysordid is '交易序号';
comment on column ${iol_schema}.ibms_ttrd_otc_order.remain_amount4confirm is '审批单的剩余审批额度';
comment on column ${iol_schema}.ibms_ttrd_otc_order.out_state is '外部状态：0或null 成功；1 通知中；2 失败';
comment on column ${iol_schema}.ibms_ttrd_otc_order.task_ordinal is '审批中时 审批单在流程中的任务步骤序号';
comment on column ${iol_schema}.ibms_ttrd_otc_order.cancelorback is '撤销 0 退回 1（在审批单状态等于9时，标记是撤销还是退回）';
comment on column ${iol_schema}.ibms_ttrd_otc_order.remain_amount4quote is '剩余报价额度';
comment on column ${iol_schema}.ibms_ttrd_otc_order.relation_ord_id is '关联审批单号';
comment on column ${iol_schema}.ibms_ttrd_otc_order.cm_attr_master is '主从属性	0：无主从关系的交易 -1：存在主从关系的交易且当前交易为主交易 >0：存在主从关系并且当前交易为从交易（填写主交易的交易号）';
comment on column ${iol_schema}.ibms_ttrd_otc_order.cm_attr_relation is '关联属性 0：无关联属性 >0：具有相同的关联号的交易需要一起成交确认';
comment on column ${iol_schema}.ibms_ttrd_otc_order.is_for_cfets is '1：默认值，上下行关心的审批单 0：对上下行屏蔽的审批单';
comment on column ${iol_schema}.ibms_ttrd_otc_order.match_mode is 'p:（默认值）支持部分匹配 e: 只能精准匹配(协议回购的现券审批单)';
comment on column ${iol_schema}.ibms_ttrd_otc_order.xcc_submit_date is '';
comment on column ${iol_schema}.ibms_ttrd_otc_order.xcc_completed_date is '';
comment on column ${iol_schema}.ibms_ttrd_otc_order.xcc_withdraw_user is '注销人id';
comment on column ${iol_schema}.ibms_ttrd_otc_order.start_dt is '开始时间';
comment on column ${iol_schema}.ibms_ttrd_otc_order.end_dt is '结束时间';
comment on column ${iol_schema}.ibms_ttrd_otc_order.id_mark is '增删标志';
comment on column ${iol_schema}.ibms_ttrd_otc_order.etl_timestamp is 'ETL处理时间戳';
