/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_online_liudai
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_online_liudai
whenever sqlerror continue none;
drop table ${iol_schema}.icms_online_liudai purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_online_liudai(
    serialno varchar2(32) -- 在线贴现申请流水号
    ,purchaserpercent number(24,6) -- 买方承担比例
    ,otherpayment varchar2(2000) -- 流贷其他支付方式
    ,totalcopies varchar2(10) -- 合同总份数
    ,yfaddress varchar2(200) -- 乙方送达地址
    ,certdn varchar2(128) -- 用户秘钥
    ,bargainorpercent number(24,6) -- 卖方承担比例
    ,inputtime varchar2(20) -- 申请发起时间
    ,partsum number(24,6) -- 受托支付起始金额
    ,otherloancondition varchar2(2000) -- 流贷其他贷款发放条件
    ,migtflag varchar2(80) -- 
    ,status varchar2(2) -- 流贷申请状态:01-待处理02-审批中03-已放款04-已驳回
    ,notarizationflag varchar2(1) -- 是否强制执行公证
    ,partybduty varchar2(40) -- 流贷借款人法定代表人职务
    ,loancondition varchar2(2) -- 流贷：1本合同生效后2本合同已经生效，并且相关的担保合同已经签署，需要办理登记或备案、公证手续的，相关手续已经办妥3其他
    ,afeerate number(24,6) -- 承兑手续费
    ,term varchar2(10) -- 流贷贷款期限（格式：2017/04/21）
    ,partyacopies varchar2(10) -- 甲方执合同份数
    ,contractname varchar2(200) -- 流贷借新还旧合同名称
    ,businesssum number(24,6) -- 流贷贷款金额
    ,otherpurpose varchar2(2000) -- 流贷其他贷款用途
    ,othersolution varchar2(4000) -- 其他争议解决方式
    ,electronpurpose varchar2(10) -- 流贷电子合同中贷款用途选项Purpose
    ,payment varchar2(2) -- 流贷：1全额受托支付2部分受托支付3全额自主支付4其他
    ,jyseriano varchar2(32) -- 唯一标识
    ,arbitration varchar2(80) -- 仲裁机构
    ,otherpaymentcondition varchar2(2000) -- 流贷其他支付条件
    ,mfcustomerid varchar2(32) -- 核心客户号
    ,acceptinttype varchar2(10) -- 贴现利息承担方式
    ,informcycle varchar2(200) -- 流贷支付情况告知周期
    ,purchaser varchar2(80) -- 买方
    ,solution varchar2(10) -- 争议解决方式
    ,contractno varchar2(32) -- 关联合同流水号
    ,contractno1 varchar2(32) -- 流贷借新还旧合同编号
    ,otherpaymentchangecondition varchar2(2000) -- 流贷其他支付方式变更条件
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
grant select on ${iol_schema}.icms_online_liudai to ${iml_schema};
grant select on ${iol_schema}.icms_online_liudai to ${icl_schema};
grant select on ${iol_schema}.icms_online_liudai to ${idl_schema};
grant select on ${iol_schema}.icms_online_liudai to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_online_liudai is '在线流贷申请表';
comment on column ${iol_schema}.icms_online_liudai.serialno is '在线贴现申请流水号';
comment on column ${iol_schema}.icms_online_liudai.purchaserpercent is '买方承担比例';
comment on column ${iol_schema}.icms_online_liudai.otherpayment is '流贷其他支付方式';
comment on column ${iol_schema}.icms_online_liudai.totalcopies is '合同总份数';
comment on column ${iol_schema}.icms_online_liudai.yfaddress is '乙方送达地址';
comment on column ${iol_schema}.icms_online_liudai.certdn is '用户秘钥';
comment on column ${iol_schema}.icms_online_liudai.bargainorpercent is '卖方承担比例';
comment on column ${iol_schema}.icms_online_liudai.inputtime is '申请发起时间';
comment on column ${iol_schema}.icms_online_liudai.partsum is '受托支付起始金额';
comment on column ${iol_schema}.icms_online_liudai.otherloancondition is '流贷其他贷款发放条件';
comment on column ${iol_schema}.icms_online_liudai.migtflag is '';
comment on column ${iol_schema}.icms_online_liudai.status is '流贷申请状态:01-待处理02-审批中03-已放款04-已驳回';
comment on column ${iol_schema}.icms_online_liudai.notarizationflag is '是否强制执行公证';
comment on column ${iol_schema}.icms_online_liudai.partybduty is '流贷借款人法定代表人职务';
comment on column ${iol_schema}.icms_online_liudai.loancondition is '流贷：1本合同生效后2本合同已经生效，并且相关的担保合同已经签署，需要办理登记或备案、公证手续的，相关手续已经办妥3其他';
comment on column ${iol_schema}.icms_online_liudai.afeerate is '承兑手续费';
comment on column ${iol_schema}.icms_online_liudai.term is '流贷贷款期限（格式：2017/04/21）';
comment on column ${iol_schema}.icms_online_liudai.partyacopies is '甲方执合同份数';
comment on column ${iol_schema}.icms_online_liudai.contractname is '流贷借新还旧合同名称';
comment on column ${iol_schema}.icms_online_liudai.businesssum is '流贷贷款金额';
comment on column ${iol_schema}.icms_online_liudai.otherpurpose is '流贷其他贷款用途';
comment on column ${iol_schema}.icms_online_liudai.othersolution is '其他争议解决方式';
comment on column ${iol_schema}.icms_online_liudai.electronpurpose is '流贷电子合同中贷款用途选项Purpose';
comment on column ${iol_schema}.icms_online_liudai.payment is '流贷：1全额受托支付2部分受托支付3全额自主支付4其他';
comment on column ${iol_schema}.icms_online_liudai.jyseriano is '唯一标识';
comment on column ${iol_schema}.icms_online_liudai.arbitration is '仲裁机构';
comment on column ${iol_schema}.icms_online_liudai.otherpaymentcondition is '流贷其他支付条件';
comment on column ${iol_schema}.icms_online_liudai.mfcustomerid is '核心客户号';
comment on column ${iol_schema}.icms_online_liudai.acceptinttype is '贴现利息承担方式';
comment on column ${iol_schema}.icms_online_liudai.informcycle is '流贷支付情况告知周期';
comment on column ${iol_schema}.icms_online_liudai.purchaser is '买方';
comment on column ${iol_schema}.icms_online_liudai.solution is '争议解决方式';
comment on column ${iol_schema}.icms_online_liudai.contractno is '关联合同流水号';
comment on column ${iol_schema}.icms_online_liudai.contractno1 is '流贷借新还旧合同编号';
comment on column ${iol_schema}.icms_online_liudai.otherpaymentchangecondition is '流贷其他支付方式变更条件';
comment on column ${iol_schema}.icms_online_liudai.start_dt is '开始时间';
comment on column ${iol_schema}.icms_online_liudai.end_dt is '结束时间';
comment on column ${iol_schema}.icms_online_liudai.id_mark is '增删标志';
comment on column ${iol_schema}.icms_online_liudai.etl_timestamp is 'ETL处理时间戳';
