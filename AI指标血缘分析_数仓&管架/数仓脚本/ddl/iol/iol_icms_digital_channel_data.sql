/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_digital_channel_data
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_digital_channel_data
whenever sqlerror continue none;
drop table ${iol_schema}.icms_digital_channel_data purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_digital_channel_data(
    serialno varchar2(40) -- 流水号
    ,contractno varchar2(40) -- 额度合同流水号
    ,phasetype varchar2(40) -- 额度业务阶段(0.额度终审失败1.额度终审成功2.已生成额度合同，3.额度合同已出账4.额度合同已签行章5.额度合同已签客户章)
    ,putoutno varchar2(40) -- 出账流水号
    ,inputdate date -- 登记时间
    ,orderno varchar2(40) -- 订单号
    ,ywblipstatus varchar2(2) -- 业务影像状态
    ,blipinfo varchar2(400) -- 影像路径
    ,updatedate date -- 更新时间
    ,customername varchar2(80) -- 客户姓名
    ,respstatus varchar2(2) -- 额度审批结果（S：申请已受理E:申请未受理)
    ,ordersumamt number(24,6) -- 订单金额
    ,applysum number(24,6) -- 额度初审金额
    ,remark varchar2(400) -- 备注
    ,edblipinfo varchar2(4000) -- 额度影像路径
    ,customerid varchar2(40) -- 客户号
    ,applyserialno varchar2(40) -- 授信申请流水号
    ,ywblipinfo varchar2(4000) -- 业务影像路径
    ,mfcustomerid varchar2(40) -- 核心客户号
    ,duebillno varchar2(40) -- 借据流水号
    ,channel varchar2(40) -- 渠道
    ,billamt number(24,6) -- 服务费
    ,applystatus varchar2(2) -- 额度初审结果(成功失败）
    ,approvesum number(24,6) -- 额度终审金额
    ,updateorgid varchar2(12) -- 更新机构
    ,contractno1 varchar2(40) -- 业务合同流水号
    ,migtflag varchar2(80) -- 迁移标志：crsrcrilcupl
    ,respinfo varchar2(400) -- 额度审批失败原因（成功：申请已受理失败：具体未受理的原因）
    ,edblipstatus varchar2(2) -- 额度影像状态
    ,inputuserid varchar2(8) -- 登记人
    ,updateuserid varchar2(8) -- 更新人
    ,approvestatus varchar2(2) -- 额度终审结果(成功失败）
    ,inputorgid varchar2(12) -- 登记机构
    ,otherinfo varchar2(4000) -- 线上渠道业务数据
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
grant select on ${iol_schema}.icms_digital_channel_data to ${iml_schema};
grant select on ${iol_schema}.icms_digital_channel_data to ${icl_schema};
grant select on ${iol_schema}.icms_digital_channel_data to ${idl_schema};
grant select on ${iol_schema}.icms_digital_channel_data to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_digital_channel_data is '线上渠道业务数据';
comment on column ${iol_schema}.icms_digital_channel_data.serialno is '流水号';
comment on column ${iol_schema}.icms_digital_channel_data.contractno is '额度合同流水号';
comment on column ${iol_schema}.icms_digital_channel_data.phasetype is '额度业务阶段(0.额度终审失败1.额度终审成功2.已生成额度合同，3.额度合同已出账4.额度合同已签行章5.额度合同已签客户章)';
comment on column ${iol_schema}.icms_digital_channel_data.putoutno is '出账流水号';
comment on column ${iol_schema}.icms_digital_channel_data.inputdate is '登记时间';
comment on column ${iol_schema}.icms_digital_channel_data.orderno is '订单号';
comment on column ${iol_schema}.icms_digital_channel_data.ywblipstatus is '业务影像状态';
comment on column ${iol_schema}.icms_digital_channel_data.blipinfo is '影像路径';
comment on column ${iol_schema}.icms_digital_channel_data.updatedate is '更新时间';
comment on column ${iol_schema}.icms_digital_channel_data.customername is '客户姓名';
comment on column ${iol_schema}.icms_digital_channel_data.respstatus is '额度审批结果（S：申请已受理E:申请未受理)';
comment on column ${iol_schema}.icms_digital_channel_data.ordersumamt is '订单金额';
comment on column ${iol_schema}.icms_digital_channel_data.applysum is '额度初审金额';
comment on column ${iol_schema}.icms_digital_channel_data.remark is '备注';
comment on column ${iol_schema}.icms_digital_channel_data.edblipinfo is '额度影像路径';
comment on column ${iol_schema}.icms_digital_channel_data.customerid is '客户号';
comment on column ${iol_schema}.icms_digital_channel_data.applyserialno is '授信申请流水号';
comment on column ${iol_schema}.icms_digital_channel_data.ywblipinfo is '业务影像路径';
comment on column ${iol_schema}.icms_digital_channel_data.mfcustomerid is '核心客户号';
comment on column ${iol_schema}.icms_digital_channel_data.duebillno is '借据流水号';
comment on column ${iol_schema}.icms_digital_channel_data.channel is '渠道';
comment on column ${iol_schema}.icms_digital_channel_data.billamt is '服务费';
comment on column ${iol_schema}.icms_digital_channel_data.applystatus is '额度初审结果(成功失败）';
comment on column ${iol_schema}.icms_digital_channel_data.approvesum is '额度终审金额';
comment on column ${iol_schema}.icms_digital_channel_data.updateorgid is '更新机构';
comment on column ${iol_schema}.icms_digital_channel_data.contractno1 is '业务合同流水号';
comment on column ${iol_schema}.icms_digital_channel_data.migtflag is '迁移标志：crsrcrilcupl';
comment on column ${iol_schema}.icms_digital_channel_data.respinfo is '额度审批失败原因（成功：申请已受理失败：具体未受理的原因）';
comment on column ${iol_schema}.icms_digital_channel_data.edblipstatus is '额度影像状态';
comment on column ${iol_schema}.icms_digital_channel_data.inputuserid is '登记人';
comment on column ${iol_schema}.icms_digital_channel_data.updateuserid is '更新人';
comment on column ${iol_schema}.icms_digital_channel_data.approvestatus is '额度终审结果(成功失败）';
comment on column ${iol_schema}.icms_digital_channel_data.inputorgid is '登记机构';
comment on column ${iol_schema}.icms_digital_channel_data.otherinfo is '线上渠道业务数据';
comment on column ${iol_schema}.icms_digital_channel_data.start_dt is '开始时间';
comment on column ${iol_schema}.icms_digital_channel_data.end_dt is '结束时间';
comment on column ${iol_schema}.icms_digital_channel_data.id_mark is '增删标志';
comment on column ${iol_schema}.icms_digital_channel_data.etl_timestamp is 'ETL处理时间戳';
