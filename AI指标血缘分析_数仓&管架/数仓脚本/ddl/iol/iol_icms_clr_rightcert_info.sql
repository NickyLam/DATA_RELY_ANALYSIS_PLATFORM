/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_clr_rightcert_info
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_clr_rightcert_info
whenever sqlerror continue none;
drop table ${iol_schema}.icms_clr_rightcert_info purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_clr_rightcert_info(
    rightcertid varchar2(96) -- 权证编号
    ,rightcertname varchar2(240) -- 权证名称
    ,clrid varchar2(96) -- 押品编号
    ,guarantyplanno varchar2(96) -- 担保方案编号
    ,sourcesystem varchar2(96) -- 源系统
    ,rightcerttype varchar2(54) -- 权证类型
    ,rightcertno varchar2(1200) -- 权证登记号码
    ,rightregistrationorg varchar2(240) -- 权证颁发机构名称
    ,rightregistrationdate date -- 权证登记时间
    ,packageid varchar2(96) -- 最新的权证所属封包
    ,barcode varchar2(96) -- 条形码
    ,transferdate date -- 移交日期
    ,rightcertstatus varchar2(54) -- 权证状态类型
    ,rightamount number(24,6) -- 权利金额
    ,possessortype varchar2(18) -- 权证持有者类型
    ,isneedwarehousing varchar2(3) -- 是否需要入库
    ,inwarehousingdate date -- 正式入库日期
    ,outwarehousingdate date -- 正式出库日期
    ,tempoutwhreason date -- 临时出库日期
    ,lastoutwhdate date -- 最近一次出库日期
    ,lastinwhdate date -- 最近一次入库日期
    ,expcreturndate date -- 临时出库预计归还日期
    ,isoverdue varchar2(3) -- 临时出库是否逾期
    ,overduedays number(18,2) -- 临时出库逾期天数
    ,isdataconv varchar2(3) -- 是否为移植
    ,registrationuserid varchar2(240) -- 抵质押办证人
    ,rightduedate date -- 权证到期日
    ,clrownerid varchar2(96) -- 权属人编号
    ,clrownername varchar2(240) -- 权属人名称
    ,saveorgid varchar2(96) -- 保存机构编号
    ,catalogflag varchar2(54) -- 区分权证和代保品,2：权证1：代保品
    ,clrownerstartdate date -- 登记日期
    ,clrownerenddate date -- 登记有效终止日期
    ,currency varchar2(54) -- 币种
    ,guarantyregno varchar2(96) -- 抵押登记编号
    ,moneyin number(24,6) -- 入账金额
    ,moneyintype varchar2(54) -- 入账金额类型
    ,bookstatus varchar2(54) -- 记账状态
    ,rightregorgtype varchar2(18) -- 登记机构类型
    ,inputuserid varchar2(96) -- 登记人
    ,inputorgid varchar2(96) -- 登记机构
    ,inputdate timestamp -- 登记日期
    ,updateuserid varchar2(96) -- 更新人
    ,updateorgid varchar2(96) -- 更新机构
    ,updatedate timestamp -- 更新日期
    ,corporgid varchar2(96) -- 法人机构编号
    ,remark varchar2(3000) -- 备注
    ,oldclrid varchar2(3000) -- 合并前押品编号
    ,twobarcodes varchar2(4000) -- 二维码
    ,migtflag varchar2(80) -- 迁移标识：rs rcr ilc upl mim
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
grant select on ${iol_schema}.icms_clr_rightcert_info to ${iml_schema};
grant select on ${iol_schema}.icms_clr_rightcert_info to ${icl_schema};
grant select on ${iol_schema}.icms_clr_rightcert_info to ${idl_schema};
grant select on ${iol_schema}.icms_clr_rightcert_info to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_clr_rightcert_info is '抵质押权证信息';
comment on column ${iol_schema}.icms_clr_rightcert_info.rightcertid is '权证编号';
comment on column ${iol_schema}.icms_clr_rightcert_info.rightcertname is '权证名称';
comment on column ${iol_schema}.icms_clr_rightcert_info.clrid is '押品编号';
comment on column ${iol_schema}.icms_clr_rightcert_info.guarantyplanno is '担保方案编号';
comment on column ${iol_schema}.icms_clr_rightcert_info.sourcesystem is '源系统';
comment on column ${iol_schema}.icms_clr_rightcert_info.rightcerttype is '权证类型';
comment on column ${iol_schema}.icms_clr_rightcert_info.rightcertno is '权证登记号码';
comment on column ${iol_schema}.icms_clr_rightcert_info.rightregistrationorg is '权证颁发机构名称';
comment on column ${iol_schema}.icms_clr_rightcert_info.rightregistrationdate is '权证登记时间';
comment on column ${iol_schema}.icms_clr_rightcert_info.packageid is '最新的权证所属封包';
comment on column ${iol_schema}.icms_clr_rightcert_info.barcode is '条形码';
comment on column ${iol_schema}.icms_clr_rightcert_info.transferdate is '移交日期';
comment on column ${iol_schema}.icms_clr_rightcert_info.rightcertstatus is '权证状态类型';
comment on column ${iol_schema}.icms_clr_rightcert_info.rightamount is '权利金额';
comment on column ${iol_schema}.icms_clr_rightcert_info.possessortype is '权证持有者类型';
comment on column ${iol_schema}.icms_clr_rightcert_info.isneedwarehousing is '是否需要入库';
comment on column ${iol_schema}.icms_clr_rightcert_info.inwarehousingdate is '正式入库日期';
comment on column ${iol_schema}.icms_clr_rightcert_info.outwarehousingdate is '正式出库日期';
comment on column ${iol_schema}.icms_clr_rightcert_info.tempoutwhreason is '临时出库日期';
comment on column ${iol_schema}.icms_clr_rightcert_info.lastoutwhdate is '最近一次出库日期';
comment on column ${iol_schema}.icms_clr_rightcert_info.lastinwhdate is '最近一次入库日期';
comment on column ${iol_schema}.icms_clr_rightcert_info.expcreturndate is '临时出库预计归还日期';
comment on column ${iol_schema}.icms_clr_rightcert_info.isoverdue is '临时出库是否逾期';
comment on column ${iol_schema}.icms_clr_rightcert_info.overduedays is '临时出库逾期天数';
comment on column ${iol_schema}.icms_clr_rightcert_info.isdataconv is '是否为移植';
comment on column ${iol_schema}.icms_clr_rightcert_info.registrationuserid is '抵质押办证人';
comment on column ${iol_schema}.icms_clr_rightcert_info.rightduedate is '权证到期日';
comment on column ${iol_schema}.icms_clr_rightcert_info.clrownerid is '权属人编号';
comment on column ${iol_schema}.icms_clr_rightcert_info.clrownername is '权属人名称';
comment on column ${iol_schema}.icms_clr_rightcert_info.saveorgid is '保存机构编号';
comment on column ${iol_schema}.icms_clr_rightcert_info.catalogflag is '区分权证和代保品,2：权证1：代保品';
comment on column ${iol_schema}.icms_clr_rightcert_info.clrownerstartdate is '登记日期';
comment on column ${iol_schema}.icms_clr_rightcert_info.clrownerenddate is '登记有效终止日期';
comment on column ${iol_schema}.icms_clr_rightcert_info.currency is '币种';
comment on column ${iol_schema}.icms_clr_rightcert_info.guarantyregno is '抵押登记编号';
comment on column ${iol_schema}.icms_clr_rightcert_info.moneyin is '入账金额';
comment on column ${iol_schema}.icms_clr_rightcert_info.moneyintype is '入账金额类型';
comment on column ${iol_schema}.icms_clr_rightcert_info.bookstatus is '记账状态';
comment on column ${iol_schema}.icms_clr_rightcert_info.rightregorgtype is '登记机构类型';
comment on column ${iol_schema}.icms_clr_rightcert_info.inputuserid is '登记人';
comment on column ${iol_schema}.icms_clr_rightcert_info.inputorgid is '登记机构';
comment on column ${iol_schema}.icms_clr_rightcert_info.inputdate is '登记日期';
comment on column ${iol_schema}.icms_clr_rightcert_info.updateuserid is '更新人';
comment on column ${iol_schema}.icms_clr_rightcert_info.updateorgid is '更新机构';
comment on column ${iol_schema}.icms_clr_rightcert_info.updatedate is '更新日期';
comment on column ${iol_schema}.icms_clr_rightcert_info.corporgid is '法人机构编号';
comment on column ${iol_schema}.icms_clr_rightcert_info.remark is '备注';
comment on column ${iol_schema}.icms_clr_rightcert_info.oldclrid is '合并前押品编号';
comment on column ${iol_schema}.icms_clr_rightcert_info.twobarcodes is '二维码';
comment on column ${iol_schema}.icms_clr_rightcert_info.migtflag is '迁移标识：rs rcr ilc upl mim';
comment on column ${iol_schema}.icms_clr_rightcert_info.start_dt is '开始时间';
comment on column ${iol_schema}.icms_clr_rightcert_info.end_dt is '结束时间';
comment on column ${iol_schema}.icms_clr_rightcert_info.id_mark is '增删标志';
comment on column ${iol_schema}.icms_clr_rightcert_info.etl_timestamp is 'ETL处理时间戳';
