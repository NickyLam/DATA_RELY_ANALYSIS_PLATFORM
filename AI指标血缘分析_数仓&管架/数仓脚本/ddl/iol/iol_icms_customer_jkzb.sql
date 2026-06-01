/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_customer_jkzb
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_customer_jkzb
whenever sqlerror continue none;
drop table ${iol_schema}.icms_customer_jkzb purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_customer_jkzb(
    serialno varchar2(32) -- 流水号
    ,updateuserid varchar2(32) -- 更新人编号
    ,yzldscale number(24,6) -- 优质流动性资产充足率（%）
    ,zygdjzb number(24,6) -- 自营固定收益类证券及证券衍生品/净资本
    ,rzzlscale number(24,6) -- 融资租赁质量偏离度（%）
    ,mrfsassets number(24,6) -- 买入返售金融资产（亿元）
    ,xtbcscale number(24,6) -- 信托报酬率（%）
    ,dykhrzscale number(24,6) -- 对单一客户融资业务规模与净资本比例（%）
    ,zqjzbscale number(24,6) -- 持有一种权益类证券的成本与净资本比例（%）
    ,jincome number(24,6) -- 净利润（亿元）
    ,yqcreditscale number(24,6) -- 逾期贷款比例（%）
    ,chbhscale number(24,6) -- 实际偿付能力额度变化率（%）
    ,cdscale1 number(24,6) -- 存贷比（%）——人民币
    ,gzcreditscale number(24,6) -- 关注贷款比例（%）
    ,ldfgscale number(24,6) -- 流动性覆盖率（%）
    ,dqbxscale number(24,6) -- 短期险保费收入增长率（%）
    ,badzlscale number(24,6) -- 不良融资租赁资产率（%）
    ,yskinvest number(24,6) -- 应收款项类投资（亿元）
    ,zbczscale number(24,6) -- 资本充足率（%）
    ,belongyear varchar2(10) -- 指标所属年度
    ,llzhscale number(24,6) -- 两年综合成本率
    ,stockb number(24,6) -- 股本（亿元）
    ,inputtime date -- 创建时间
    ,jzcfz number(24,6) -- 净资产/负债
    ,gzldkye number(24,6) -- 关注类贷款余额（万元）
    ,updatetime date -- 更新时间
    ,ljckscale number(24,6) -- 累计外汇敞口头寸占资本净额比例
    ,yjzbscale number(24,6) -- 一级资本充足率（%）
    ,zlchannel varchar2(150) -- 资料来源
    ,zlbfscale number(24,6) -- 自留保费增长率
    ,jsdgpscale number(24,6) -- 接受单只担保股票市值与该股票总市值比例（%）
    ,badrzzlscale number(24,6) -- 拨备覆盖不良融资租赁资产率（%）
    ,rjdqsczz number(22,4) -- 
    ,gainzb number(24,6) -- 净资本（亿元）
    ,ldxscale2 number(24,6) -- 流动性比例（%）——外币
    ,coreyjscale number(24,6) -- 核心一级资本充足率（%）
    ,dbscale number(24,6) -- 担保比例（%）
    ,zcsum number(24,6) -- 总资产（亿元）
    ,zzcscale number(24,6) -- 总资产收益率（%）（即资产利润率）
    ,dykhjzbscale number(24,6) -- 对单一客户融券业务规模与净资本比例（%）
    ,zqszscale number(24,6) -- 持有一种权益类证券市值与其总市值的比例（%）
    ,baddkye number(24,6) -- 不良贷款余额（万元）
    ,ldxscale1 number(24,6) -- 流动性比例（%）——人民币
    ,jwdzjscale number(24,6) -- 净稳定资金率（%）
    ,jzbjfz number(24,6) -- 净资本/负债
    ,dkssscale number(24,6) -- 贷款损失准备充足率（%）
    ,bdscale number(24,6) -- 拨贷比（即拨备覆盖率）（%）
    ,pjdlscale number(24,6) -- 平均代理证券业务净收入（亿元）
    ,cqtzscale number(24,6) -- 长期投资比例（%）
    ,dygdjzd varchar2(10) -- 单一股东及其关联方授信集中度
    ,xtsrscale number(24,6) -- 信托业务收入占比（%）
    ,zbsyscale number(24,6) -- 资本收益率（%）（即资本利润率）
    ,bcreditpydscale number(24,6) -- 不良贷款与预期贷款偏离度（%）
    ,cfllscale number(24,6) -- 偿付能力充足率（%）
    ,jzbjzc number(24,6) -- 净资本/净资产
    ,stockdqy number(24,6) -- 股东权益（亿元）
    ,rjprofit number(24,6) -- 人均利润（万元）
    ,ditzscale number(24,6) -- 短期投资比例（%）
    ,tycrscale number(24,6) -- 同业拆入比例（%）
    ,cbsrscale number(24,6) -- 成本收入比（%）
    ,migtflag varchar2(80) -- 迁移标志：crsrcrilcupl
    ,cqbxscale number(24,6) -- 长期险保费收入增长率（%）
    ,bfzzscale number(24,6) -- 保费增长率
    ,zyqxjzb number(24,6) -- 自营权益类证券及证券衍生品/净资本
    ,fxfgscale number(24,6) -- 风险覆盖率（%）
    ,customerid varchar2(32) -- 监管客户编号
    ,badscale number(24,6) -- 不良资产率（%）
    ,dyjtglscale number(24,6) -- 单一客户关联度（%）
    ,bfrzscale number(24,6) -- 批发性融资比例（%）
    ,dkzlzcgm varchar2(24) -- 贷款/融资租赁资产规模
    ,ldxscale3 number(24,6) -- 流动性比例（%）——本外币
    ,businessjsr number(24,6) -- 营业净收入（亿元）
    ,fxtzzbscale number(24,6) -- 风险调整资本回报率（%）
    ,tbscale number(24,6) -- 退保率（%）
    ,dyjtsxscale number(24,6) -- 单一集团客户授信集中度（%）
    ,inputorg varchar2(32) -- 操作人所在机构
    ,dqsczs number(22,4) -- 
    ,jtkfscale number(24,6) -- 集团客户关联度（%）
    ,yqbadzlscale number(24,6) -- 逾期90天以上融资租赁与不良融资租赁比例（%）
    ,zbjye number(24,6) -- 各项准备金余额（万元）
    ,zzggscale number(24,6) -- 资本杠杆率（%）
    ,dkscope number(24,6) -- 贷款规模（亿元）
    ,cdscale2 number(24,6) -- 存贷比（%）——外币
    ,cdscale3 number(24,6) -- 存贷比（%）——本外币
    ,jwdscale number(24,6) -- 净稳定资金比例（%）
    ,ldppscale number(24,6) -- 流动性匹配率（%）
    ,dyjtjzscale number(24,6) -- 单一客户集中度（%）
    ,badcreditscale number(24,6) -- 不良贷款比例（%）
    ,inputuser varchar2(32) -- 操作人
    ,updateorgid varchar2(32) -- 更新人所在机构编号
    ,zcglscope number(24,6) -- 资产管理规模（亿元）
    ,ckscope number(24,6) -- 存款规模（亿元）
    ,registercountrycode varchar2(64) -- 注册国家代码
    ,countryrating varchar2(64) -- 所在国家评级
    ,countrycapstandard number(18,2) -- 所在国家或地区监管部门的最低资本监管要求
    ,countryaddoncapital number(18,2) -- 所在国家或地区监管部门公开发布的监管法规中缓冲资本要求
    ,coretieronerate number(18,2) -- 核心一级资本充足率
    ,tieronerate number(18,2) -- 一级资本充足率
    ,capitaladeratio number(18,2) -- 资本充足率
    ,leveragerate number(18,2) -- 杠杆率
    ,auditcommnent varchar2(1000) -- 外部审计意见
    ,riskalert varchar2(10) -- 尽职调查发现存在重大风险情形
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
grant select on ${iol_schema}.icms_customer_jkzb to ${iml_schema};
grant select on ${iol_schema}.icms_customer_jkzb to ${icl_schema};
grant select on ${iol_schema}.icms_customer_jkzb to ${idl_schema};
grant select on ${iol_schema}.icms_customer_jkzb to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_customer_jkzb is '监管指标';
comment on column ${iol_schema}.icms_customer_jkzb.serialno is '流水号';
comment on column ${iol_schema}.icms_customer_jkzb.updateuserid is '更新人编号';
comment on column ${iol_schema}.icms_customer_jkzb.yzldscale is '优质流动性资产充足率（%）';
comment on column ${iol_schema}.icms_customer_jkzb.zygdjzb is '自营固定收益类证券及证券衍生品/净资本';
comment on column ${iol_schema}.icms_customer_jkzb.rzzlscale is '融资租赁质量偏离度（%）';
comment on column ${iol_schema}.icms_customer_jkzb.mrfsassets is '买入返售金融资产（亿元）';
comment on column ${iol_schema}.icms_customer_jkzb.xtbcscale is '信托报酬率（%）';
comment on column ${iol_schema}.icms_customer_jkzb.dykhrzscale is '对单一客户融资业务规模与净资本比例（%）';
comment on column ${iol_schema}.icms_customer_jkzb.zqjzbscale is '持有一种权益类证券的成本与净资本比例（%）';
comment on column ${iol_schema}.icms_customer_jkzb.jincome is '净利润（亿元）';
comment on column ${iol_schema}.icms_customer_jkzb.yqcreditscale is '逾期贷款比例（%）';
comment on column ${iol_schema}.icms_customer_jkzb.chbhscale is '实际偿付能力额度变化率（%）';
comment on column ${iol_schema}.icms_customer_jkzb.cdscale1 is '存贷比（%）——人民币';
comment on column ${iol_schema}.icms_customer_jkzb.gzcreditscale is '关注贷款比例（%）';
comment on column ${iol_schema}.icms_customer_jkzb.ldfgscale is '流动性覆盖率（%）';
comment on column ${iol_schema}.icms_customer_jkzb.dqbxscale is '短期险保费收入增长率（%）';
comment on column ${iol_schema}.icms_customer_jkzb.badzlscale is '不良融资租赁资产率（%）';
comment on column ${iol_schema}.icms_customer_jkzb.yskinvest is '应收款项类投资（亿元）';
comment on column ${iol_schema}.icms_customer_jkzb.zbczscale is '资本充足率（%）';
comment on column ${iol_schema}.icms_customer_jkzb.belongyear is '指标所属年度';
comment on column ${iol_schema}.icms_customer_jkzb.llzhscale is '两年综合成本率';
comment on column ${iol_schema}.icms_customer_jkzb.stockb is '股本（亿元）';
comment on column ${iol_schema}.icms_customer_jkzb.inputtime is '创建时间';
comment on column ${iol_schema}.icms_customer_jkzb.jzcfz is '净资产/负债';
comment on column ${iol_schema}.icms_customer_jkzb.gzldkye is '关注类贷款余额（万元）';
comment on column ${iol_schema}.icms_customer_jkzb.updatetime is '更新时间';
comment on column ${iol_schema}.icms_customer_jkzb.ljckscale is '累计外汇敞口头寸占资本净额比例';
comment on column ${iol_schema}.icms_customer_jkzb.yjzbscale is '一级资本充足率（%）';
comment on column ${iol_schema}.icms_customer_jkzb.zlchannel is '资料来源';
comment on column ${iol_schema}.icms_customer_jkzb.zlbfscale is '自留保费增长率';
comment on column ${iol_schema}.icms_customer_jkzb.jsdgpscale is '接受单只担保股票市值与该股票总市值比例（%）';
comment on column ${iol_schema}.icms_customer_jkzb.badrzzlscale is '拨备覆盖不良融资租赁资产率（%）';
comment on column ${iol_schema}.icms_customer_jkzb.rjdqsczz is '';
comment on column ${iol_schema}.icms_customer_jkzb.gainzb is '净资本（亿元）';
comment on column ${iol_schema}.icms_customer_jkzb.ldxscale2 is '流动性比例（%）——外币';
comment on column ${iol_schema}.icms_customer_jkzb.coreyjscale is '核心一级资本充足率（%）';
comment on column ${iol_schema}.icms_customer_jkzb.dbscale is '担保比例（%）';
comment on column ${iol_schema}.icms_customer_jkzb.zcsum is '总资产（亿元）';
comment on column ${iol_schema}.icms_customer_jkzb.zzcscale is '总资产收益率（%）（即资产利润率）';
comment on column ${iol_schema}.icms_customer_jkzb.dykhjzbscale is '对单一客户融券业务规模与净资本比例（%）';
comment on column ${iol_schema}.icms_customer_jkzb.zqszscale is '持有一种权益类证券市值与其总市值的比例（%）';
comment on column ${iol_schema}.icms_customer_jkzb.baddkye is '不良贷款余额（万元）';
comment on column ${iol_schema}.icms_customer_jkzb.ldxscale1 is '流动性比例（%）——人民币';
comment on column ${iol_schema}.icms_customer_jkzb.jwdzjscale is '净稳定资金率（%）';
comment on column ${iol_schema}.icms_customer_jkzb.jzbjfz is '净资本/负债';
comment on column ${iol_schema}.icms_customer_jkzb.dkssscale is '贷款损失准备充足率（%）';
comment on column ${iol_schema}.icms_customer_jkzb.bdscale is '拨贷比（即拨备覆盖率）（%）';
comment on column ${iol_schema}.icms_customer_jkzb.pjdlscale is '平均代理证券业务净收入（亿元）';
comment on column ${iol_schema}.icms_customer_jkzb.cqtzscale is '长期投资比例（%）';
comment on column ${iol_schema}.icms_customer_jkzb.dygdjzd is '单一股东及其关联方授信集中度';
comment on column ${iol_schema}.icms_customer_jkzb.xtsrscale is '信托业务收入占比（%）';
comment on column ${iol_schema}.icms_customer_jkzb.zbsyscale is '资本收益率（%）（即资本利润率）';
comment on column ${iol_schema}.icms_customer_jkzb.bcreditpydscale is '不良贷款与预期贷款偏离度（%）';
comment on column ${iol_schema}.icms_customer_jkzb.cfllscale is '偿付能力充足率（%）';
comment on column ${iol_schema}.icms_customer_jkzb.jzbjzc is '净资本/净资产';
comment on column ${iol_schema}.icms_customer_jkzb.stockdqy is '股东权益（亿元）';
comment on column ${iol_schema}.icms_customer_jkzb.rjprofit is '人均利润（万元）';
comment on column ${iol_schema}.icms_customer_jkzb.ditzscale is '短期投资比例（%）';
comment on column ${iol_schema}.icms_customer_jkzb.tycrscale is '同业拆入比例（%）';
comment on column ${iol_schema}.icms_customer_jkzb.cbsrscale is '成本收入比（%）';
comment on column ${iol_schema}.icms_customer_jkzb.migtflag is '迁移标志：crsrcrilcupl';
comment on column ${iol_schema}.icms_customer_jkzb.cqbxscale is '长期险保费收入增长率（%）';
comment on column ${iol_schema}.icms_customer_jkzb.bfzzscale is '保费增长率';
comment on column ${iol_schema}.icms_customer_jkzb.zyqxjzb is '自营权益类证券及证券衍生品/净资本';
comment on column ${iol_schema}.icms_customer_jkzb.fxfgscale is '风险覆盖率（%）';
comment on column ${iol_schema}.icms_customer_jkzb.customerid is '监管客户编号';
comment on column ${iol_schema}.icms_customer_jkzb.badscale is '不良资产率（%）';
comment on column ${iol_schema}.icms_customer_jkzb.dyjtglscale is '单一客户关联度（%）';
comment on column ${iol_schema}.icms_customer_jkzb.bfrzscale is '批发性融资比例（%）';
comment on column ${iol_schema}.icms_customer_jkzb.dkzlzcgm is '贷款/融资租赁资产规模';
comment on column ${iol_schema}.icms_customer_jkzb.ldxscale3 is '流动性比例（%）——本外币';
comment on column ${iol_schema}.icms_customer_jkzb.businessjsr is '营业净收入（亿元）';
comment on column ${iol_schema}.icms_customer_jkzb.fxtzzbscale is '风险调整资本回报率（%）';
comment on column ${iol_schema}.icms_customer_jkzb.tbscale is '退保率（%）';
comment on column ${iol_schema}.icms_customer_jkzb.dyjtsxscale is '单一集团客户授信集中度（%）';
comment on column ${iol_schema}.icms_customer_jkzb.inputorg is '操作人所在机构';
comment on column ${iol_schema}.icms_customer_jkzb.dqsczs is '';
comment on column ${iol_schema}.icms_customer_jkzb.jtkfscale is '集团客户关联度（%）';
comment on column ${iol_schema}.icms_customer_jkzb.yqbadzlscale is '逾期90天以上融资租赁与不良融资租赁比例（%）';
comment on column ${iol_schema}.icms_customer_jkzb.zbjye is '各项准备金余额（万元）';
comment on column ${iol_schema}.icms_customer_jkzb.zzggscale is '资本杠杆率（%）';
comment on column ${iol_schema}.icms_customer_jkzb.dkscope is '贷款规模（亿元）';
comment on column ${iol_schema}.icms_customer_jkzb.cdscale2 is '存贷比（%）——外币';
comment on column ${iol_schema}.icms_customer_jkzb.cdscale3 is '存贷比（%）——本外币';
comment on column ${iol_schema}.icms_customer_jkzb.jwdscale is '净稳定资金比例（%）';
comment on column ${iol_schema}.icms_customer_jkzb.ldppscale is '流动性匹配率（%）';
comment on column ${iol_schema}.icms_customer_jkzb.dyjtjzscale is '单一客户集中度（%）';
comment on column ${iol_schema}.icms_customer_jkzb.badcreditscale is '不良贷款比例（%）';
comment on column ${iol_schema}.icms_customer_jkzb.inputuser is '操作人';
comment on column ${iol_schema}.icms_customer_jkzb.updateorgid is '更新人所在机构编号';
comment on column ${iol_schema}.icms_customer_jkzb.zcglscope is '资产管理规模（亿元）';
comment on column ${iol_schema}.icms_customer_jkzb.ckscope is '存款规模（亿元）';
comment on column ${iol_schema}.icms_customer_jkzb.registercountrycode is '注册国家代码';
comment on column ${iol_schema}.icms_customer_jkzb.countryrating is '所在国家评级';
comment on column ${iol_schema}.icms_customer_jkzb.countrycapstandard is '所在国家或地区监管部门的最低资本监管要求';
comment on column ${iol_schema}.icms_customer_jkzb.countryaddoncapital is '所在国家或地区监管部门公开发布的监管法规中缓冲资本要求';
comment on column ${iol_schema}.icms_customer_jkzb.coretieronerate is '核心一级资本充足率';
comment on column ${iol_schema}.icms_customer_jkzb.tieronerate is '一级资本充足率';
comment on column ${iol_schema}.icms_customer_jkzb.capitaladeratio is '资本充足率';
comment on column ${iol_schema}.icms_customer_jkzb.leveragerate is '杠杆率';
comment on column ${iol_schema}.icms_customer_jkzb.auditcommnent is '外部审计意见';
comment on column ${iol_schema}.icms_customer_jkzb.riskalert is '尽职调查发现存在重大风险情形';
comment on column ${iol_schema}.icms_customer_jkzb.start_dt is '开始时间';
comment on column ${iol_schema}.icms_customer_jkzb.end_dt is '结束时间';
comment on column ${iol_schema}.icms_customer_jkzb.id_mark is '增删标志';
comment on column ${iol_schema}.icms_customer_jkzb.etl_timestamp is 'ETL处理时间戳';
