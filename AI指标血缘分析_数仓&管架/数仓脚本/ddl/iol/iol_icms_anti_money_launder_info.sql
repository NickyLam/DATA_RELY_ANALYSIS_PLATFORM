/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_anti_money_launder_info
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_anti_money_launder_info
whenever sqlerror continue none;
drop table ${iol_schema}.icms_anti_money_launder_info purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_anti_money_launder_info(
    serialno varchar2(32) -- 流水号
    ,objectno varchar2(64) -- 关联流水号
    ,objecttype varchar2(40) -- 关联类型
    ,resultcode varchar2(2) -- 检索结果代码
    ,resultinfo varchar2(256) -- 检索结果
    ,levelname varchar2(8) -- 风险等级
    ,recordid varchar2(64) -- 检索结果的主表记录ID
    ,warningstatus varchar2(16) -- 预警状态
    ,approvestatus varchar2(16) -- 审批状态
    ,reasonurl varchar2(4000) -- 查看预警信息命中原因URL
    ,inputuserid varchar2(16) -- 登记人
    ,inputorgid varchar2(16) -- 登记机构
    ,inputdate date -- 登记日期
    ,updateuserid varchar2(16) -- 更新人
    ,updateorgid varchar2(16) -- 更新机构
    ,updatedate date -- 更新日期
    ,checkresult varchar2(1) -- 处理结果：0-待处理；1-放行；2-拦截；X-终止交易
    ,checkcntt varchar2(4000) -- 审核内容
    ,remark varchar2(4000) -- 备注
    ,certid varchar2(60) -- 证件号码
    ,certtype varchar2(32) -- 证件类型
    ,ismoneylaunder varchar2(1) -- 是否命中反洗钱
    ,riskadvice varchar2(512) -- 风控措施建议
    ,risktype varchar2(32) -- 风控措施类别
    ,transid varchar2(32) -- 对应发风控最新的事件流水号
    ,customername varchar2(200) -- 客户名称
    ,applyphase varchar2(64) -- 申请阶段编号
    ,inclusiondate date -- 名单收录日期
    ,sourcecode varchar2(32) -- 名单来源代码
    ,tokenid varchar2(255) -- 反洗钱tokenId
    ,fxqrecordid varchar2(255) -- 反洗钱命中预警ID
    ,groupinfo varchar2(4000) -- 名单命中实际分组
    ,querypriptype varchar2(32) -- 查询主体类型
    ,counterpartyaccount varchar2(32) -- 交易对手账户
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
grant select on ${iol_schema}.icms_anti_money_launder_info to ${iml_schema};
grant select on ${iol_schema}.icms_anti_money_launder_info to ${icl_schema};
grant select on ${iol_schema}.icms_anti_money_launder_info to ${idl_schema};
grant select on ${iol_schema}.icms_anti_money_launder_info to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_anti_money_launder_info is '反洗钱申请表';
comment on column ${iol_schema}.icms_anti_money_launder_info.serialno is '流水号';
comment on column ${iol_schema}.icms_anti_money_launder_info.objectno is '关联流水号';
comment on column ${iol_schema}.icms_anti_money_launder_info.objecttype is '关联类型';
comment on column ${iol_schema}.icms_anti_money_launder_info.resultcode is '检索结果代码';
comment on column ${iol_schema}.icms_anti_money_launder_info.resultinfo is '检索结果';
comment on column ${iol_schema}.icms_anti_money_launder_info.levelname is '风险等级';
comment on column ${iol_schema}.icms_anti_money_launder_info.recordid is '检索结果的主表记录ID';
comment on column ${iol_schema}.icms_anti_money_launder_info.warningstatus is '预警状态';
comment on column ${iol_schema}.icms_anti_money_launder_info.approvestatus is '审批状态';
comment on column ${iol_schema}.icms_anti_money_launder_info.reasonurl is '查看预警信息命中原因URL';
comment on column ${iol_schema}.icms_anti_money_launder_info.inputuserid is '登记人';
comment on column ${iol_schema}.icms_anti_money_launder_info.inputorgid is '登记机构';
comment on column ${iol_schema}.icms_anti_money_launder_info.inputdate is '登记日期';
comment on column ${iol_schema}.icms_anti_money_launder_info.updateuserid is '更新人';
comment on column ${iol_schema}.icms_anti_money_launder_info.updateorgid is '更新机构';
comment on column ${iol_schema}.icms_anti_money_launder_info.updatedate is '更新日期';
comment on column ${iol_schema}.icms_anti_money_launder_info.checkresult is '处理结果：0-待处理；1-放行；2-拦截；X-终止交易';
comment on column ${iol_schema}.icms_anti_money_launder_info.checkcntt is '审核内容';
comment on column ${iol_schema}.icms_anti_money_launder_info.remark is '备注';
comment on column ${iol_schema}.icms_anti_money_launder_info.certid is '证件号码';
comment on column ${iol_schema}.icms_anti_money_launder_info.certtype is '证件类型';
comment on column ${iol_schema}.icms_anti_money_launder_info.ismoneylaunder is '是否命中反洗钱';
comment on column ${iol_schema}.icms_anti_money_launder_info.riskadvice is '风控措施建议';
comment on column ${iol_schema}.icms_anti_money_launder_info.risktype is '风控措施类别';
comment on column ${iol_schema}.icms_anti_money_launder_info.transid is '对应发风控最新的事件流水号';
comment on column ${iol_schema}.icms_anti_money_launder_info.customername is '客户名称';
comment on column ${iol_schema}.icms_anti_money_launder_info.applyphase is '申请阶段编号';
comment on column ${iol_schema}.icms_anti_money_launder_info.inclusiondate is '名单收录日期';
comment on column ${iol_schema}.icms_anti_money_launder_info.sourcecode is '名单来源代码';
comment on column ${iol_schema}.icms_anti_money_launder_info.tokenid is '反洗钱tokenId';
comment on column ${iol_schema}.icms_anti_money_launder_info.fxqrecordid is '反洗钱命中预警ID';
comment on column ${iol_schema}.icms_anti_money_launder_info.groupinfo is '名单命中实际分组';
comment on column ${iol_schema}.icms_anti_money_launder_info.querypriptype is '查询主体类型';
comment on column ${iol_schema}.icms_anti_money_launder_info.counterpartyaccount is '交易对手账户';
comment on column ${iol_schema}.icms_anti_money_launder_info.start_dt is '开始时间';
comment on column ${iol_schema}.icms_anti_money_launder_info.end_dt is '结束时间';
comment on column ${iol_schema}.icms_anti_money_launder_info.id_mark is '增删标志';
comment on column ${iol_schema}.icms_anti_money_launder_info.etl_timestamp is 'ETL处理时间戳';
