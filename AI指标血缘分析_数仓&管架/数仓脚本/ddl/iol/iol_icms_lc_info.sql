/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_lc_info
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_lc_info
whenever sqlerror continue none;
drop table ${iol_schema}.icms_lc_info purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_lc_info(
    serialno varchar2(32) -- 流水号
    ,objecttype varchar2(32) -- 对象类型
    ,objectno varchar2(18) -- 对象编号
    ,issuebank varchar2(80) -- 开卡行
    ,applicantaddress varchar2(200) -- 申请人地址
    ,lctype varchar2(18) -- 信用证类型
    ,lcsum number(24,6) -- 金额
    ,importcargo varchar2(80) -- 进口货物
    ,pricearticle varchar2(800) -- 价格条款
    ,beneficiaryaddress varchar2(200) -- 受益人地址
    ,lccurrency varchar2(18) -- 币种
    ,lcterm number(22) -- 远期信用证付款期限
    ,authcertno varchar2(32) -- 进口许可证或批文
    ,informstate varchar2(80) -- 通知行国家
    ,inputdate varchar2(10) -- 登记日期
    ,purpose varchar2(200) -- 用途
    ,flag1 varchar2(18) -- 远期信用证是否已承兑
    ,remark varchar2(200) -- 备注
    ,lcno varchar2(32) -- 信用证编号
    ,informbank varchar2(80) -- 通知行
    ,applicant varchar2(80) -- 借款人
    ,tradesum number(24,6) -- 议付单据金额(元)
    ,freightbilltype varchar2(18) -- 货运单据种类
    ,issuestate varchar2(80) -- 开证国家
    ,updatedate varchar2(10) -- 更新日期
    ,loadingdate date -- 开证日期
    ,inputuserid varchar2(32) -- 登记人
    ,inputorgid varchar2(32) -- 登记机构
    ,issuedate varchar2(10) -- 开卡日期
    ,beneficiary varchar2(80) -- 受益人
    ,validdate varchar2(10) -- 信用证效期
    ,importtype varchar2(18) -- 进口方式
    ,contractno varchar2(32) -- 汽车买卖合同编号
    ,exporter varchar2(80) -- 出口国
    ,documentdate varchar2(10) -- 信用证交单期
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
grant select on ${iol_schema}.icms_lc_info to ${iml_schema};
grant select on ${iol_schema}.icms_lc_info to ${icl_schema};
grant select on ${iol_schema}.icms_lc_info to ${idl_schema};
grant select on ${iol_schema}.icms_lc_info to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_lc_info is '相关信用证信息';
comment on column ${iol_schema}.icms_lc_info.serialno is '流水号';
comment on column ${iol_schema}.icms_lc_info.objecttype is '对象类型';
comment on column ${iol_schema}.icms_lc_info.objectno is '对象编号';
comment on column ${iol_schema}.icms_lc_info.issuebank is '开卡行';
comment on column ${iol_schema}.icms_lc_info.applicantaddress is '申请人地址';
comment on column ${iol_schema}.icms_lc_info.lctype is '信用证类型';
comment on column ${iol_schema}.icms_lc_info.lcsum is '金额';
comment on column ${iol_schema}.icms_lc_info.importcargo is '进口货物';
comment on column ${iol_schema}.icms_lc_info.pricearticle is '价格条款';
comment on column ${iol_schema}.icms_lc_info.beneficiaryaddress is '受益人地址';
comment on column ${iol_schema}.icms_lc_info.lccurrency is '币种';
comment on column ${iol_schema}.icms_lc_info.lcterm is '远期信用证付款期限';
comment on column ${iol_schema}.icms_lc_info.authcertno is '进口许可证或批文';
comment on column ${iol_schema}.icms_lc_info.informstate is '通知行国家';
comment on column ${iol_schema}.icms_lc_info.inputdate is '登记日期';
comment on column ${iol_schema}.icms_lc_info.purpose is '用途';
comment on column ${iol_schema}.icms_lc_info.flag1 is '远期信用证是否已承兑';
comment on column ${iol_schema}.icms_lc_info.remark is '备注';
comment on column ${iol_schema}.icms_lc_info.lcno is '信用证编号';
comment on column ${iol_schema}.icms_lc_info.informbank is '通知行';
comment on column ${iol_schema}.icms_lc_info.applicant is '借款人';
comment on column ${iol_schema}.icms_lc_info.tradesum is '议付单据金额(元)';
comment on column ${iol_schema}.icms_lc_info.freightbilltype is '货运单据种类';
comment on column ${iol_schema}.icms_lc_info.issuestate is '开证国家';
comment on column ${iol_schema}.icms_lc_info.updatedate is '更新日期';
comment on column ${iol_schema}.icms_lc_info.loadingdate is '开证日期';
comment on column ${iol_schema}.icms_lc_info.inputuserid is '登记人';
comment on column ${iol_schema}.icms_lc_info.inputorgid is '登记机构';
comment on column ${iol_schema}.icms_lc_info.issuedate is '开卡日期';
comment on column ${iol_schema}.icms_lc_info.beneficiary is '受益人';
comment on column ${iol_schema}.icms_lc_info.validdate is '信用证效期';
comment on column ${iol_schema}.icms_lc_info.importtype is '进口方式';
comment on column ${iol_schema}.icms_lc_info.contractno is '汽车买卖合同编号';
comment on column ${iol_schema}.icms_lc_info.exporter is '出口国';
comment on column ${iol_schema}.icms_lc_info.documentdate is '信用证交单期';
comment on column ${iol_schema}.icms_lc_info.start_dt is '开始时间';
comment on column ${iol_schema}.icms_lc_info.end_dt is '结束时间';
comment on column ${iol_schema}.icms_lc_info.id_mark is '增删标志';
comment on column ${iol_schema}.icms_lc_info.etl_timestamp is 'ETL处理时间戳';
