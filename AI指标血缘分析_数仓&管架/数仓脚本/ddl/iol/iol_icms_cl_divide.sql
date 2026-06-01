/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_cl_divide
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_cl_divide
whenever sqlerror continue none;
drop table ${iol_schema}.icms_cl_divide purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_cl_divide(
    serialno varchar2(64) -- 流水号
    ,migtflag varchar2(80) -- 迁移标志：crsrcrilcupl
    ,parentserialno varchar2(64) -- 上层切分编号上层分配编号
    ,channel varchar2(10) -- 渠道
    ,objectno varchar2(64) -- 对象编号
    ,ifexclusivecredit varchar2(2) -- 是否专属额度
    ,updatedate date -- 更新日期
    ,availableexposuresum number(24,6) -- 可用敞口金额
    ,ownercustid varchar2(64) -- 额度所属客户(汇总层额度存上次额度客户)
    ,objecttype varchar2(64) -- 对象类型
    ,minbusinessrate number(15,8) -- 最低利率
    ,lowriskexposuresum number(24,6) -- 类低风险敞口金额
    ,oldobjectno varchar2(64) -- 关联迁出方对象编号
    ,riskexposuresum number(24,6) -- 其中，一般风险敞口限额
    ,nominalsum number(24,6) -- 名义金额
    ,othercommand varchar2(1000) -- 其他要求
    ,cycleflag varchar2(2) -- 是否循环
    ,currency varchar2(3) -- 币种币种(默认为顶层额度币种)
    ,availablenominalsum number(24,6) -- 可用名义金额
    ,status varchar2(36) -- 状态
    ,inputdate date -- 登记日期
    ,divideobjecttype varchar2(64) -- 切分对象类型CLDIVIDEOBJECTTYPE（产品、客户、机构）
    ,divideobjectno varchar2(4000) -- 切分对象编号
    ,occupynominalsum number(24,6) -- 已用名义金额已用名义金额(自动计算)
    ,minbailrate number(24,8) -- 最低保证金比例
    ,guarantytype varchar2(20) -- 担保类型
    ,exposuresum number(24,6) -- 敞口金额
    ,inputuserid varchar2(64) -- 登记人
    ,inputorgid varchar2(64) -- 登记机构
    ,termmonth number(22) -- 期限
    ,oldobjecttype varchar2(64) -- 关联迁出方对象类型
    ,occupyexposuresum number(24,6) -- 已用敞口金额已用敞口金额(自动计算)
    ,maxbusinesssum number(24,6) -- 最高单笔金额
    ,migtoldvalue varchar2(250) -- 迁移数据-参数转换前字段值
    ,originserialno varchar2(64) -- 
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
grant select on ${iol_schema}.icms_cl_divide to ${iml_schema};
grant select on ${iol_schema}.icms_cl_divide to ${icl_schema};
grant select on ${iol_schema}.icms_cl_divide to ${idl_schema};
grant select on ${iol_schema}.icms_cl_divide to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_cl_divide is '额度切分表额度切分表';
comment on column ${iol_schema}.icms_cl_divide.serialno is '流水号';
comment on column ${iol_schema}.icms_cl_divide.migtflag is '迁移标志：crsrcrilcupl';
comment on column ${iol_schema}.icms_cl_divide.parentserialno is '上层切分编号上层分配编号';
comment on column ${iol_schema}.icms_cl_divide.channel is '渠道';
comment on column ${iol_schema}.icms_cl_divide.objectno is '对象编号';
comment on column ${iol_schema}.icms_cl_divide.ifexclusivecredit is '是否专属额度';
comment on column ${iol_schema}.icms_cl_divide.updatedate is '更新日期';
comment on column ${iol_schema}.icms_cl_divide.availableexposuresum is '可用敞口金额';
comment on column ${iol_schema}.icms_cl_divide.ownercustid is '额度所属客户(汇总层额度存上次额度客户)';
comment on column ${iol_schema}.icms_cl_divide.objecttype is '对象类型';
comment on column ${iol_schema}.icms_cl_divide.minbusinessrate is '最低利率';
comment on column ${iol_schema}.icms_cl_divide.lowriskexposuresum is '类低风险敞口金额';
comment on column ${iol_schema}.icms_cl_divide.oldobjectno is '关联迁出方对象编号';
comment on column ${iol_schema}.icms_cl_divide.riskexposuresum is '其中，一般风险敞口限额';
comment on column ${iol_schema}.icms_cl_divide.nominalsum is '名义金额';
comment on column ${iol_schema}.icms_cl_divide.othercommand is '其他要求';
comment on column ${iol_schema}.icms_cl_divide.cycleflag is '是否循环';
comment on column ${iol_schema}.icms_cl_divide.currency is '币种币种(默认为顶层额度币种)';
comment on column ${iol_schema}.icms_cl_divide.availablenominalsum is '可用名义金额';
comment on column ${iol_schema}.icms_cl_divide.status is '状态';
comment on column ${iol_schema}.icms_cl_divide.inputdate is '登记日期';
comment on column ${iol_schema}.icms_cl_divide.divideobjecttype is '切分对象类型CLDIVIDEOBJECTTYPE（产品、客户、机构）';
comment on column ${iol_schema}.icms_cl_divide.divideobjectno is '切分对象编号';
comment on column ${iol_schema}.icms_cl_divide.occupynominalsum is '已用名义金额已用名义金额(自动计算)';
comment on column ${iol_schema}.icms_cl_divide.minbailrate is '最低保证金比例';
comment on column ${iol_schema}.icms_cl_divide.guarantytype is '担保类型';
comment on column ${iol_schema}.icms_cl_divide.exposuresum is '敞口金额';
comment on column ${iol_schema}.icms_cl_divide.inputuserid is '登记人';
comment on column ${iol_schema}.icms_cl_divide.inputorgid is '登记机构';
comment on column ${iol_schema}.icms_cl_divide.termmonth is '期限';
comment on column ${iol_schema}.icms_cl_divide.oldobjecttype is '关联迁出方对象类型';
comment on column ${iol_schema}.icms_cl_divide.occupyexposuresum is '已用敞口金额已用敞口金额(自动计算)';
comment on column ${iol_schema}.icms_cl_divide.maxbusinesssum is '最高单笔金额';
comment on column ${iol_schema}.icms_cl_divide.migtoldvalue is '迁移数据-参数转换前字段值';
comment on column ${iol_schema}.icms_cl_divide.originserialno is '';
comment on column ${iol_schema}.icms_cl_divide.start_dt is '开始时间';
comment on column ${iol_schema}.icms_cl_divide.end_dt is '结束时间';
comment on column ${iol_schema}.icms_cl_divide.id_mark is '增删标志';
comment on column ${iol_schema}.icms_cl_divide.etl_timestamp is 'ETL处理时间戳';
