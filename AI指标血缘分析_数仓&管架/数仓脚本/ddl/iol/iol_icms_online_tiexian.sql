/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_online_tiexian
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_online_tiexian
whenever sqlerror continue none;
drop table ${iol_schema}.icms_online_tiexian purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_online_tiexian(
    serialno varchar2(32) -- 在线贴现申请流水号
    ,mfcustomerid varchar2(32) -- 核心客户号
    ,purchaser varchar2(80) -- 买方
    ,solution varchar2(10) -- 争议解决方式
    ,belongorgid varchar2(32) -- 
    ,partyaprincipal varchar2(200) -- 贴现人负责人(新增)
    ,afeerate number(24,6) -- 贴现利率
    ,partyacopies varchar2(10) -- 甲方执合同份数
    ,totalcopies varchar2(10) -- 合同总份数
    ,partyaduty varchar2(200) -- 贴现人负责人职务(新增)
    ,partybname varchar2(200) -- 申请人名称(新增)
    ,partybaddress varchar2(2000) -- 申请人地址(新增)
    ,notarizationflag varchar2(1) -- 是否强制执行公证
    ,jfaddress varchar2(200) -- 甲方送达地址
    ,partyaphone varchar2(20) -- 贴现人电话(新增)
    ,isautobusi varchar2(2) -- 秒贴业务标记,码值：是1否2(新增)
    ,partybduty varchar2(200) -- 申请人法定代表人职务(新增)
    ,status varchar2(2) -- 贴现申请状态:01-待处理02-审批中03-已放款04-已驳回
    ,jyseriano varchar2(32) -- 交易门户唯一标识
    ,certdn varchar2(128) -- 用户秘钥
    ,partyblegalperson varchar2(200) -- 申请人法定代表人(新增)
    ,errormsg varchar2(4000) -- 秒贴业务错误信息(新增)
    ,migtflag varchar2(80) -- 迁移标志：crsrcrilcupl
    ,othersolution varchar2(4000) -- 其他争议解决方式
    ,arbitration varchar2(80) -- 仲裁机构
    ,purchaserpercent number(24,6) -- 买方承担比例
    ,contractno varchar2(32) -- 关联合同流水号
    ,acceptinttype varchar2(10) -- 贴现利息承担方式
    ,partyaaddress varchar2(2000) -- 贴现人地址(新增)
    ,yfaddress varchar2(200) -- 交易门户唯一标识
    ,isnoedflow varchar2(2) -- 是否无额度银承
    ,partybphone varchar2(20) -- 申请人电话(新增)
    ,partybfax varchar2(200) -- 申请人传真(新增)
    ,bargainorpercent number(24,6) -- 卖方承担比例
    ,inputtime varchar2(20) -- 申请发起时间
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
grant select on ${iol_schema}.icms_online_tiexian to ${iml_schema};
grant select on ${iol_schema}.icms_online_tiexian to ${icl_schema};
grant select on ${iol_schema}.icms_online_tiexian to ${idl_schema};
grant select on ${iol_schema}.icms_online_tiexian to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_online_tiexian is '在线贴现申请表';
comment on column ${iol_schema}.icms_online_tiexian.serialno is '在线贴现申请流水号';
comment on column ${iol_schema}.icms_online_tiexian.mfcustomerid is '核心客户号';
comment on column ${iol_schema}.icms_online_tiexian.purchaser is '买方';
comment on column ${iol_schema}.icms_online_tiexian.solution is '争议解决方式';
comment on column ${iol_schema}.icms_online_tiexian.belongorgid is '';
comment on column ${iol_schema}.icms_online_tiexian.partyaprincipal is '贴现人负责人(新增)';
comment on column ${iol_schema}.icms_online_tiexian.afeerate is '贴现利率';
comment on column ${iol_schema}.icms_online_tiexian.partyacopies is '甲方执合同份数';
comment on column ${iol_schema}.icms_online_tiexian.totalcopies is '合同总份数';
comment on column ${iol_schema}.icms_online_tiexian.partyaduty is '贴现人负责人职务(新增)';
comment on column ${iol_schema}.icms_online_tiexian.partybname is '申请人名称(新增)';
comment on column ${iol_schema}.icms_online_tiexian.partybaddress is '申请人地址(新增)';
comment on column ${iol_schema}.icms_online_tiexian.notarizationflag is '是否强制执行公证';
comment on column ${iol_schema}.icms_online_tiexian.jfaddress is '甲方送达地址';
comment on column ${iol_schema}.icms_online_tiexian.partyaphone is '贴现人电话(新增)';
comment on column ${iol_schema}.icms_online_tiexian.isautobusi is '秒贴业务标记,码值：是1否2(新增)';
comment on column ${iol_schema}.icms_online_tiexian.partybduty is '申请人法定代表人职务(新增)';
comment on column ${iol_schema}.icms_online_tiexian.status is '贴现申请状态:01-待处理02-审批中03-已放款04-已驳回';
comment on column ${iol_schema}.icms_online_tiexian.jyseriano is '交易门户唯一标识';
comment on column ${iol_schema}.icms_online_tiexian.certdn is '用户秘钥';
comment on column ${iol_schema}.icms_online_tiexian.partyblegalperson is '申请人法定代表人(新增)';
comment on column ${iol_schema}.icms_online_tiexian.errormsg is '秒贴业务错误信息(新增)';
comment on column ${iol_schema}.icms_online_tiexian.migtflag is '迁移标志：crsrcrilcupl';
comment on column ${iol_schema}.icms_online_tiexian.othersolution is '其他争议解决方式';
comment on column ${iol_schema}.icms_online_tiexian.arbitration is '仲裁机构';
comment on column ${iol_schema}.icms_online_tiexian.purchaserpercent is '买方承担比例';
comment on column ${iol_schema}.icms_online_tiexian.contractno is '关联合同流水号';
comment on column ${iol_schema}.icms_online_tiexian.acceptinttype is '贴现利息承担方式';
comment on column ${iol_schema}.icms_online_tiexian.partyaaddress is '贴现人地址(新增)';
comment on column ${iol_schema}.icms_online_tiexian.yfaddress is '交易门户唯一标识';
comment on column ${iol_schema}.icms_online_tiexian.isnoedflow is '是否无额度银承';
comment on column ${iol_schema}.icms_online_tiexian.partybphone is '申请人电话(新增)';
comment on column ${iol_schema}.icms_online_tiexian.partybfax is '申请人传真(新增)';
comment on column ${iol_schema}.icms_online_tiexian.bargainorpercent is '卖方承担比例';
comment on column ${iol_schema}.icms_online_tiexian.inputtime is '申请发起时间';
comment on column ${iol_schema}.icms_online_tiexian.start_dt is '开始时间';
comment on column ${iol_schema}.icms_online_tiexian.end_dt is '结束时间';
comment on column ${iol_schema}.icms_online_tiexian.id_mark is '增删标志';
comment on column ${iol_schema}.icms_online_tiexian.etl_timestamp is 'ETL处理时间戳';
