/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_online_yincheng
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_online_yincheng
whenever sqlerror continue none;
drop table ${iol_schema}.icms_online_yincheng purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_online_yincheng(
    serialno varchar2(32) -- 在线贴现申请流水号
    ,purchaserpercent number(24,6) -- 买方承担比例
    ,solution varchar2(10) -- 争议解决方式
    ,othersolution varchar2(4000) -- 其他争议解决方式
    ,totalcopies varchar2(10) -- 合同总份数
    ,contractno varchar2(32) -- 关联合同流水号
    ,jyseriano varchar2(32) -- 交易门户唯一标识
    ,mfcustomerid varchar2(32) -- 核心客户号
    ,purchaser varchar2(80) -- 买方
    ,partyacopies varchar2(10) -- 甲方执合同份数
    ,inputtime varchar2(20) -- 申请发起时间
    ,notarizationflag varchar2(1) -- 是否强制执行公证
    ,yfaddress varchar2(200) -- 乙方送达地址（承兑电子合同用）
    ,jfaddress varchar2(200) -- 甲方送达地址
    ,status varchar2(2) -- 银承申请状态:01-待处理02-审批中03-已放款04-已驳回
    ,acceptinttype varchar2(10) -- 贴现利息承担方式
    ,certdn varchar2(128) -- 用户秘钥
    ,arbitration varchar2(80) -- 仲裁机构
    ,migtflag varchar2(80) -- 
    ,afeerate number(24,6) -- 承兑手续费
    ,bargainorpercent number(24,6) -- 卖方承担比例
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
grant select on ${iol_schema}.icms_online_yincheng to ${iml_schema};
grant select on ${iol_schema}.icms_online_yincheng to ${icl_schema};
grant select on ${iol_schema}.icms_online_yincheng to ${idl_schema};
grant select on ${iol_schema}.icms_online_yincheng to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_online_yincheng is '在线银承申请表';
comment on column ${iol_schema}.icms_online_yincheng.serialno is '在线贴现申请流水号';
comment on column ${iol_schema}.icms_online_yincheng.purchaserpercent is '买方承担比例';
comment on column ${iol_schema}.icms_online_yincheng.solution is '争议解决方式';
comment on column ${iol_schema}.icms_online_yincheng.othersolution is '其他争议解决方式';
comment on column ${iol_schema}.icms_online_yincheng.totalcopies is '合同总份数';
comment on column ${iol_schema}.icms_online_yincheng.contractno is '关联合同流水号';
comment on column ${iol_schema}.icms_online_yincheng.jyseriano is '交易门户唯一标识';
comment on column ${iol_schema}.icms_online_yincheng.mfcustomerid is '核心客户号';
comment on column ${iol_schema}.icms_online_yincheng.purchaser is '买方';
comment on column ${iol_schema}.icms_online_yincheng.partyacopies is '甲方执合同份数';
comment on column ${iol_schema}.icms_online_yincheng.inputtime is '申请发起时间';
comment on column ${iol_schema}.icms_online_yincheng.notarizationflag is '是否强制执行公证';
comment on column ${iol_schema}.icms_online_yincheng.yfaddress is '乙方送达地址（承兑电子合同用）';
comment on column ${iol_schema}.icms_online_yincheng.jfaddress is '甲方送达地址';
comment on column ${iol_schema}.icms_online_yincheng.status is '银承申请状态:01-待处理02-审批中03-已放款04-已驳回';
comment on column ${iol_schema}.icms_online_yincheng.acceptinttype is '贴现利息承担方式';
comment on column ${iol_schema}.icms_online_yincheng.certdn is '用户秘钥';
comment on column ${iol_schema}.icms_online_yincheng.arbitration is '仲裁机构';
comment on column ${iol_schema}.icms_online_yincheng.migtflag is '';
comment on column ${iol_schema}.icms_online_yincheng.afeerate is '承兑手续费';
comment on column ${iol_schema}.icms_online_yincheng.bargainorpercent is '卖方承担比例';
comment on column ${iol_schema}.icms_online_yincheng.start_dt is '开始时间';
comment on column ${iol_schema}.icms_online_yincheng.end_dt is '结束时间';
comment on column ${iol_schema}.icms_online_yincheng.id_mark is '增删标志';
comment on column ${iol_schema}.icms_online_yincheng.etl_timestamp is 'ETL处理时间戳';
