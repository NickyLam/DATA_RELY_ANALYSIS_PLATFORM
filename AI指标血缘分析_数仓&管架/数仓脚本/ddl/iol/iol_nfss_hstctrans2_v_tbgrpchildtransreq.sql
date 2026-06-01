/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol nfss_hstctrans2_v_tbgrpchildtransreq
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.nfss_hstctrans2_v_tbgrpchildtransreq
whenever sqlerror continue none;
drop table ${iol_schema}.nfss_hstctrans2_v_tbgrpchildtransreq purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.nfss_hstctrans2_v_tbgrpchildtransreq(
    serial_no varchar2(48) -- 流水序号:流水号
    ,ex_serial varchar2(48) -- 原始请求外部流水号
    ,model varchar2(2) -- 模式
    ,trans_code varchar2(48) -- 交易代码
    ,group_code varchar2(48) -- 分组代码
    ,prd_type varchar2(2) -- 产品类型:1-基金
    ,trans_date number(22,0) -- 交易日期
    ,trans_time number(22,0) -- 交易时间
    ,child_serial_no varchar2(48) -- 子流水号
    ,sub_trans_code varchar2(48) -- 子交易编号
    ,prd_code varchar2(48) -- 产品代码
    ,amt number(18,2) -- 金额
    ,vol number(18,3) -- 份额
    ,cfm_vol number(18,3) -- 确认份额
    ,cfm_amt number(18,2) -- 确认金额
    ,fee number(18,2) -- 手续费
    ,err_code varchar2(18) -- 错误代码
    ,err_msg varchar2(768) -- 错误信息
    ,child_status varchar2(2) -- 子交易状态:0-预受理  		  1-受理  		  2-已撤单  		  3-已抹账  		  4-失败  		  5-已导出  		  6-部分确认未全部返回  		  7-部分确认已全部返回  		  8-确认成功  		  9-确认失败  		  a-认购确认  		  b-份额调账  		  c-待撤销  		  d-分红数据  		  e-预约中  		  f-预受理处理失败  		  s-成功  		  z-处理中  		  p-待审批  		  w-已审批，待确认  		  t-超时  		  g-调仓中，交易待发起  		  h-调仓已导出  		  i-待发起  		  j-已审批  		  k-交易待导出给基金代销  		  l-已补处理  		  m-交易已导出给基金代销待确认
    ,summary varchar2(375) -- 摘要
    ,to_host_serial varchar2(48) -- 发送主机流水号
    ,check_date number(22,0) -- 对账日期
    ,ori_host_chk_date number(22,0) -- 原交易主机对账日期
    ,host_trans_code varchar2(9) -- 主机交易码
    ,host_date number(22,0) -- 核心日期:主机日期
    ,host_serial varchar2(48) -- 主机流水号
    ,liqu_status varchar2(2) -- 账务状态:[k_zwzt] 0	-	账务无关 1	-	待冻结 2	-	待扣款 3	-	已冻结 4	-	已扣款 5	-	待解冻扣款 6	-	已上账 7	-	待上账 8	-	已解冻 9	-	上账并冻结
    ,reserve1 varchar2(375) -- 保留字段1
    ,reserve2 varchar2(375) -- 保留字段2
    ,reserve3 varchar2(375) -- 保留字段3
    ,reserve4 varchar2(375) -- 保留字段4
    ,reserve5 varchar2(375) -- 保留字段5
    ,amt1 number(18,2) -- 备用金额1
    ,amt2 number(18,2) -- 备用金额2
    ,amt3 number(18,2) -- 备用金额3
    ,amt4 number(18,2) -- 备用金额4
    ,amt5 number(18,2) -- 备用金额5
    ,amt6 number(18,2) -- 备用金额6
    ,cancel_date number(22,0) -- 撤单日期
    ,cancel_time number(22,0) -- 撤单时间
    ,cfm_fee number(18,2) -- 确认手续费
    ,cfm_nav number(18,8) -- 确认净值
    ,double1 number(22,8) -- 扩展浮点数1
    ,double2 number(22,8) -- 备用double2
    ,double3 number(22,8) -- 备用double3
    ,double4 number(22,8) -- 备用double4
    ,double5 number(22,8) -- 备用double5
    ,asso_serial varchar2(48) -- 关联流水号
    ,asso_serial2 varchar2(48) -- 关联流水号2
    ,asso_serial3 varchar2(48) -- 关联流水号3
    ,agio number(5,4) -- 折扣率
    ,square_date number(22,0) -- 清算日期:原入账日期，跟公司统一名称改为清算日期
    ,in_client_no varchar2(30) -- 内部客户编号
    ,phy_date number(22,0) -- 物理日期
    ,modify_timestamp number(14,0) -- 修改时间戳
    ,cancel_amt number(18,2) -- 撤单金额
    ,cfm_date number(22,0) -- 确认日期
    ,client_manager varchar2(48) -- 客户经理
    ,etl_dt date -- ETL处理日期
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list(etl_dt)(
    partition p_19000101 values (to_date('19000101','yyyymmdd'))
)
storage (initial 64k next 64k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${iol_schema}.nfss_hstctrans2_v_tbgrpchildtransreq to ${iml_schema};
grant select on ${iol_schema}.nfss_hstctrans2_v_tbgrpchildtransreq to ${icl_schema};
grant select on ${iol_schema}.nfss_hstctrans2_v_tbgrpchildtransreq to ${idl_schema};
grant select on ${iol_schema}.nfss_hstctrans2_v_tbgrpchildtransreq to ${iel_schema};

-- comment
comment on table ${iol_schema}.nfss_hstctrans2_v_tbgrpchildtransreq is '交易子流水表';
comment on column ${iol_schema}.nfss_hstctrans2_v_tbgrpchildtransreq.serial_no is '流水序号:流水号';
comment on column ${iol_schema}.nfss_hstctrans2_v_tbgrpchildtransreq.ex_serial is '原始请求外部流水号';
comment on column ${iol_schema}.nfss_hstctrans2_v_tbgrpchildtransreq.model is '模式';
comment on column ${iol_schema}.nfss_hstctrans2_v_tbgrpchildtransreq.trans_code is '交易代码';
comment on column ${iol_schema}.nfss_hstctrans2_v_tbgrpchildtransreq.group_code is '分组代码';
comment on column ${iol_schema}.nfss_hstctrans2_v_tbgrpchildtransreq.prd_type is '产品类型:1-基金';
comment on column ${iol_schema}.nfss_hstctrans2_v_tbgrpchildtransreq.trans_date is '交易日期';
comment on column ${iol_schema}.nfss_hstctrans2_v_tbgrpchildtransreq.trans_time is '交易时间';
comment on column ${iol_schema}.nfss_hstctrans2_v_tbgrpchildtransreq.child_serial_no is '子流水号';
comment on column ${iol_schema}.nfss_hstctrans2_v_tbgrpchildtransreq.sub_trans_code is '子交易编号';
comment on column ${iol_schema}.nfss_hstctrans2_v_tbgrpchildtransreq.prd_code is '产品代码';
comment on column ${iol_schema}.nfss_hstctrans2_v_tbgrpchildtransreq.amt is '金额';
comment on column ${iol_schema}.nfss_hstctrans2_v_tbgrpchildtransreq.vol is '份额';
comment on column ${iol_schema}.nfss_hstctrans2_v_tbgrpchildtransreq.cfm_vol is '确认份额';
comment on column ${iol_schema}.nfss_hstctrans2_v_tbgrpchildtransreq.cfm_amt is '确认金额';
comment on column ${iol_schema}.nfss_hstctrans2_v_tbgrpchildtransreq.fee is '手续费';
comment on column ${iol_schema}.nfss_hstctrans2_v_tbgrpchildtransreq.err_code is '错误代码';
comment on column ${iol_schema}.nfss_hstctrans2_v_tbgrpchildtransreq.err_msg is '错误信息';
comment on column ${iol_schema}.nfss_hstctrans2_v_tbgrpchildtransreq.child_status is '子交易状态:0-预受理  		  1-受理  		  2-已撤单  		  3-已抹账  		  4-失败  		  5-已导出  		  6-部分确认未全部返回  		  7-部分确认已全部返回  		  8-确认成功  		  9-确认失败  		  a-认购确认  		  b-份额调账  		  c-待撤销  		  d-分红数据  		  e-预约中  		  f-预受理处理失败  		  s-成功  		  z-处理中  		  p-待审批  		  w-已审批，待确认  		  t-超时  		  g-调仓中，交易待发起  		  h-调仓已导出  		  i-待发起  		  j-已审批  		  k-交易待导出给基金代销  		  l-已补处理  		  m-交易已导出给基金代销待确认';
comment on column ${iol_schema}.nfss_hstctrans2_v_tbgrpchildtransreq.summary is '摘要';
comment on column ${iol_schema}.nfss_hstctrans2_v_tbgrpchildtransreq.to_host_serial is '发送主机流水号';
comment on column ${iol_schema}.nfss_hstctrans2_v_tbgrpchildtransreq.check_date is '对账日期';
comment on column ${iol_schema}.nfss_hstctrans2_v_tbgrpchildtransreq.ori_host_chk_date is '原交易主机对账日期';
comment on column ${iol_schema}.nfss_hstctrans2_v_tbgrpchildtransreq.host_trans_code is '主机交易码';
comment on column ${iol_schema}.nfss_hstctrans2_v_tbgrpchildtransreq.host_date is '核心日期:主机日期';
comment on column ${iol_schema}.nfss_hstctrans2_v_tbgrpchildtransreq.host_serial is '主机流水号';
comment on column ${iol_schema}.nfss_hstctrans2_v_tbgrpchildtransreq.liqu_status is '账务状态:[k_zwzt] 0	-	账务无关 1	-	待冻结 2	-	待扣款 3	-	已冻结 4	-	已扣款 5	-	待解冻扣款 6	-	已上账 7	-	待上账 8	-	已解冻 9	-	上账并冻结';
comment on column ${iol_schema}.nfss_hstctrans2_v_tbgrpchildtransreq.reserve1 is '保留字段1';
comment on column ${iol_schema}.nfss_hstctrans2_v_tbgrpchildtransreq.reserve2 is '保留字段2';
comment on column ${iol_schema}.nfss_hstctrans2_v_tbgrpchildtransreq.reserve3 is '保留字段3';
comment on column ${iol_schema}.nfss_hstctrans2_v_tbgrpchildtransreq.reserve4 is '保留字段4';
comment on column ${iol_schema}.nfss_hstctrans2_v_tbgrpchildtransreq.reserve5 is '保留字段5';
comment on column ${iol_schema}.nfss_hstctrans2_v_tbgrpchildtransreq.amt1 is '备用金额1';
comment on column ${iol_schema}.nfss_hstctrans2_v_tbgrpchildtransreq.amt2 is '备用金额2';
comment on column ${iol_schema}.nfss_hstctrans2_v_tbgrpchildtransreq.amt3 is '备用金额3';
comment on column ${iol_schema}.nfss_hstctrans2_v_tbgrpchildtransreq.amt4 is '备用金额4';
comment on column ${iol_schema}.nfss_hstctrans2_v_tbgrpchildtransreq.amt5 is '备用金额5';
comment on column ${iol_schema}.nfss_hstctrans2_v_tbgrpchildtransreq.amt6 is '备用金额6';
comment on column ${iol_schema}.nfss_hstctrans2_v_tbgrpchildtransreq.cancel_date is '撤单日期';
comment on column ${iol_schema}.nfss_hstctrans2_v_tbgrpchildtransreq.cancel_time is '撤单时间';
comment on column ${iol_schema}.nfss_hstctrans2_v_tbgrpchildtransreq.cfm_fee is '确认手续费';
comment on column ${iol_schema}.nfss_hstctrans2_v_tbgrpchildtransreq.cfm_nav is '确认净值';
comment on column ${iol_schema}.nfss_hstctrans2_v_tbgrpchildtransreq.double1 is '扩展浮点数1';
comment on column ${iol_schema}.nfss_hstctrans2_v_tbgrpchildtransreq.double2 is '备用double2';
comment on column ${iol_schema}.nfss_hstctrans2_v_tbgrpchildtransreq.double3 is '备用double3';
comment on column ${iol_schema}.nfss_hstctrans2_v_tbgrpchildtransreq.double4 is '备用double4';
comment on column ${iol_schema}.nfss_hstctrans2_v_tbgrpchildtransreq.double5 is '备用double5';
comment on column ${iol_schema}.nfss_hstctrans2_v_tbgrpchildtransreq.asso_serial is '关联流水号';
comment on column ${iol_schema}.nfss_hstctrans2_v_tbgrpchildtransreq.asso_serial2 is '关联流水号2';
comment on column ${iol_schema}.nfss_hstctrans2_v_tbgrpchildtransreq.asso_serial3 is '关联流水号3';
comment on column ${iol_schema}.nfss_hstctrans2_v_tbgrpchildtransreq.agio is '折扣率';
comment on column ${iol_schema}.nfss_hstctrans2_v_tbgrpchildtransreq.square_date is '清算日期:原入账日期，跟公司统一名称改为清算日期';
comment on column ${iol_schema}.nfss_hstctrans2_v_tbgrpchildtransreq.in_client_no is '内部客户编号';
comment on column ${iol_schema}.nfss_hstctrans2_v_tbgrpchildtransreq.phy_date is '物理日期';
comment on column ${iol_schema}.nfss_hstctrans2_v_tbgrpchildtransreq.modify_timestamp is '修改时间戳';
comment on column ${iol_schema}.nfss_hstctrans2_v_tbgrpchildtransreq.cancel_amt is '撤单金额';
comment on column ${iol_schema}.nfss_hstctrans2_v_tbgrpchildtransreq.cfm_date is '确认日期';
comment on column ${iol_schema}.nfss_hstctrans2_v_tbgrpchildtransreq.client_manager is '客户经理';
comment on column ${iol_schema}.nfss_hstctrans2_v_tbgrpchildtransreq.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.nfss_hstctrans2_v_tbgrpchildtransreq.etl_timestamp is 'ETL处理时间戳';
