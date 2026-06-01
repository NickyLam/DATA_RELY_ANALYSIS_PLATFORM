/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_classify_relative
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_classify_relative
whenever sqlerror continue none;
drop table ${iol_schema}.icms_classify_relative purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_classify_relative(
    serialno varchar2(64) -- 关联流水号
    ,objecttype varchar2(18) -- 关联类型
    ,objectno varchar2(64) -- 关联编号
    ,guarantorid varchar2(16) -- 保证人
    ,relativedate date -- 关联日期
    ,inputdate date -- 登记时间
    ,limitelement varchar2(10) -- 限定因素
    ,updateorgid varchar2(64) -- 更新机构
    ,remark varchar2(40) -- 备注
    ,adjustreason varchar2(1000) -- 调整理由
    ,inputuserid varchar2(64) -- 登记人
    ,vouchtype varchar2(10) -- 担保类型
    ,interestbalance number(25,6) -- 关注余额
    ,status varchar2(4) -- 状态
    ,evaluateresult varchar2(10) -- 业务评级结果
    ,guarantysum number(24,6) -- 保证总金额
    ,updateuserid varchar2(64) -- 更新人
    ,businessdescribe varchar2(1000) -- 业务模式说明/保证措施说明/预警信号描述
    ,signid varchar2(64) -- 预警信号编号
    ,migtflag varchar2(80) -- 迁移标志：crsrcrilcupl
    ,coveragearea varchar2(10) -- 覆盖率
    ,equitysituation varchar2(10) -- 股权情况
    ,businessanalyze varchar2(1000) -- 押品价格稳定性、变现能力和法律保障分析/担保能力、担保意愿和法律保障分析/我行债券保障能力分析
    ,signlevel varchar2(18) -- 预警信号级别
    ,adjust varchar2(10) -- 调整
    ,guarantorname varchar2(200) -- 保证人
    ,channel varchar2(10) -- 渠道
    ,inputorgid varchar2(64) -- 登记机构
    ,balance number(25,6) -- 借据余额
    ,updatedate date -- 更新时间
    ,afterclassifyresulteleven varchar2(20) -- 调整后11级分类
    ,lastclassifyresulteleven varchar2(20) -- 调整前11级分类
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
grant select on ${iol_schema}.icms_classify_relative to ${iml_schema};
grant select on ${iol_schema}.icms_classify_relative to ${icl_schema};
grant select on ${iol_schema}.icms_classify_relative to ${idl_schema};
grant select on ${iol_schema}.icms_classify_relative to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_classify_relative is '风险分类关联表';
comment on column ${iol_schema}.icms_classify_relative.serialno is '关联流水号';
comment on column ${iol_schema}.icms_classify_relative.objecttype is '关联类型';
comment on column ${iol_schema}.icms_classify_relative.objectno is '关联编号';
comment on column ${iol_schema}.icms_classify_relative.guarantorid is '保证人';
comment on column ${iol_schema}.icms_classify_relative.relativedate is '关联日期';
comment on column ${iol_schema}.icms_classify_relative.inputdate is '登记时间';
comment on column ${iol_schema}.icms_classify_relative.limitelement is '限定因素';
comment on column ${iol_schema}.icms_classify_relative.updateorgid is '更新机构';
comment on column ${iol_schema}.icms_classify_relative.remark is '备注';
comment on column ${iol_schema}.icms_classify_relative.adjustreason is '调整理由';
comment on column ${iol_schema}.icms_classify_relative.inputuserid is '登记人';
comment on column ${iol_schema}.icms_classify_relative.vouchtype is '担保类型';
comment on column ${iol_schema}.icms_classify_relative.interestbalance is '关注余额';
comment on column ${iol_schema}.icms_classify_relative.status is '状态';
comment on column ${iol_schema}.icms_classify_relative.evaluateresult is '业务评级结果';
comment on column ${iol_schema}.icms_classify_relative.guarantysum is '保证总金额';
comment on column ${iol_schema}.icms_classify_relative.updateuserid is '更新人';
comment on column ${iol_schema}.icms_classify_relative.businessdescribe is '业务模式说明/保证措施说明/预警信号描述';
comment on column ${iol_schema}.icms_classify_relative.signid is '预警信号编号';
comment on column ${iol_schema}.icms_classify_relative.migtflag is '迁移标志：crsrcrilcupl';
comment on column ${iol_schema}.icms_classify_relative.coveragearea is '覆盖率';
comment on column ${iol_schema}.icms_classify_relative.equitysituation is '股权情况';
comment on column ${iol_schema}.icms_classify_relative.businessanalyze is '押品价格稳定性、变现能力和法律保障分析/担保能力、担保意愿和法律保障分析/我行债券保障能力分析';
comment on column ${iol_schema}.icms_classify_relative.signlevel is '预警信号级别';
comment on column ${iol_schema}.icms_classify_relative.adjust is '调整';
comment on column ${iol_schema}.icms_classify_relative.guarantorname is '保证人';
comment on column ${iol_schema}.icms_classify_relative.channel is '渠道';
comment on column ${iol_schema}.icms_classify_relative.inputorgid is '登记机构';
comment on column ${iol_schema}.icms_classify_relative.balance is '借据余额';
comment on column ${iol_schema}.icms_classify_relative.updatedate is '更新时间';
comment on column ${iol_schema}.icms_classify_relative.afterclassifyresulteleven is '调整后11级分类';
comment on column ${iol_schema}.icms_classify_relative.lastclassifyresulteleven is '调整前11级分类';
comment on column ${iol_schema}.icms_classify_relative.start_dt is '开始时间';
comment on column ${iol_schema}.icms_classify_relative.end_dt is '结束时间';
comment on column ${iol_schema}.icms_classify_relative.id_mark is '增删标志';
comment on column ${iol_schema}.icms_classify_relative.etl_timestamp is 'ETL处理时间戳';
