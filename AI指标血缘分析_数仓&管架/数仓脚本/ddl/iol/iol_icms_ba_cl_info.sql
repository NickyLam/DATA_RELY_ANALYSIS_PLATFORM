/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_ba_cl_info
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_ba_cl_info
whenever sqlerror continue none;
drop table ${iol_schema}.icms_ba_cl_info purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_ba_cl_info(
    serialno varchar2(64) -- 流水号
    ,outclassifydate varchar2(10) -- 外部评级日期
    ,totalsumentpart number(24,6) -- 公司敞口金额(元)
    ,dlcdbz varchar2(1) -- 代理参贷标志
    ,investtarget varchar2(500) -- 投资标的
    ,othercondition varchar2(4000) -- 额度使用条件
    ,iscreditincrement varchar2(4) -- 是否有增信
    ,hxtymainratelevel varchar2(36) -- 外部主体评级
    ,migtflag varchar2(80) -- 迁移标志：CRS RCR ILC UPL
    ,channelname varchar2(200) -- 通道方名称
    ,isbillapply varchar2(10) -- 是否新增银承额度专项贴现
    ,refbankname varchar2(200) -- 参贷行行号
    ,isgovernfinance varchar2(2) -- 是否涉及政府类融资
    ,lngotimes number(22) -- 借新还旧次数
    ,mainlevelorg varchar2(400) -- 主体评级机构
    ,singlebizmostamount number(24,6) -- 额度下业务单笔最大金额
    ,riskexposuresum number(24,6) -- 其中，一般风险敞口限额
    ,nominalsum number(24,6) -- 额度名义金额
    ,isestatefinance varchar2(2) -- 是否涉及房地产融资
    ,bizextendedterm number(22) -- 额度下业务延展期限月)
    ,availableexposuresum number(24,6) -- 可用敞口金额
    ,islikeloan varchar2(2) -- 是否类信贷
    ,publishsum number(24,6) -- 本次发行金额
    ,bizmostmortgagerate number(24,8) -- 额度下业务最高抵质押率
    ,isfinancialcredit varchar2(80) -- 是否商圈授信
    ,investway varchar2(2) -- 投资方式
    ,fundsource varchar2(72) -- 资金来源
    ,playtype varchar2(2) -- 参与方式
    ,termtype varchar2(36) -- 期限申请类型额度)
    ,lineclass varchar2(36) -- 额度种类综合/专项/其他)
    ,suremodel varchar2(2) -- 是否总行认定模式
    ,managename varchar2(100) -- 管理人名称
    ,manageid varchar2(16) -- 管理人客户号
    ,istrans varchar2(2) -- 是否转授信
    ,belonggroupapproveno varchar2(32) -- 集团批复编号
    ,financialcreditowner varchar2(80) -- 集群客户专项额度所有人
    ,issmeandretail varchar2(1) -- 是否我行小微企业并且走零售条线
    ,originalname varchar2(200) -- 原始权益人名称
    ,ispubliccredit varchar2(2) -- 是否公开授信额度)
    ,occupynominalsum number(24,6) -- 已用授信额度
    ,moneyindustryt varchar2(32) -- 资金投向行业
    ,bizbailinitialrate number(24,8) -- 额度下业务初始保证金比例
    ,transcount varchar2(2) -- 交易对手个数
    ,maxnominalamount number(24,6) -- 单一最高授信额度名义金额
    ,lowriskexposuresum number(24,6) -- 其中，类低风险敞口金额(元)
    ,bizlowestfloatrate number(24,8) -- 额度下业务利率最低浮动
    ,occupyexposuresum number(24,6) -- 已用敞口金额自动计算)
    ,totalsumtypart number(24,6) -- 同业敞口金额(元)
    ,linecontrolmode varchar2(36) -- 集团额度管控模式超额分配/全额分配)
    ,latestusedate date -- 额度最迟使用日期
    ,isgreenfinance varchar2(2) -- 是否为绿色信贷融资
    ,otherlimitownerid varchar2(32) -- 他用额度所有人
    ,availablenominalsum number(24,6) -- 可用名义金额
    ,hostbankname varchar2(200) -- 主办行行名
    ,authvouchtype varchar2(18) -- 授权权限_担保方式
    ,isquerycreditreport varchar2(10) -- 是否自动查询贷后报告
    ,mainleveldate varchar2(20) -- 主体评级日期
    ,usewithoutcondition varchar2(2) -- 能否直接使用额度)
    ,isbeltroadfinance varchar2(2) -- 是否为一带一路建设投融资
    ,otherlimittype varchar2(32) -- 他用额度类型
    ,sqdkze number(18,2) -- 申请银团贷款总额(元)
    ,outclassifylevel varchar2(18) -- 外部债项评级
    ,jxhjcontractno varchar2(32) -- 借新还旧原合同
    ,businesssumentpart number(24,6) -- 公司授信额度(元)
    ,currencyrange varchar2(400) -- 项下业务币种范围
    ,isconsumerfinance varchar2(2) -- 是否为消费服务类融资
    ,drtimes number(22) -- 债务重组次数
    ,exposuresum number(24,6) -- 额度敞口金额
    ,classifyresulteleven varchar2(18) -- 债项分类
    ,issuername varchar2(120) -- 发行人名称
    ,financialcreditserialno varchar2(32) -- 集群客户专项额度流水号
    ,hxtyoperateorg varchar2(2) -- 归口管理部门
    ,issme varchar2(1) -- 是否小微企业贷款
    ,hostbankno varchar2(16) -- 主办行行号
    ,agentbankname varchar2(200) -- 代理行行号
    ,otherlimitno varchar2(32) -- 他用额度流水号
    ,creditauthno varchar2(40) -- 征信授权影像流水号
    ,agentbankno varchar2(16) -- 代理行行号
    ,approvepubsum number(24,6) -- 批准发行总额
    ,outclassifyorg varchar2(200) -- 外部评级机构名称
    ,creditarea varchar2(2) -- 授信区域
    ,publicorg varchar2(2) -- 发行场所
    ,isyhcustomer varchar2(10) -- 是否优合授信客户
    ,onlineamount number(24,6) -- 线上额度(元)
    ,refbankno varchar2(16) -- 参贷行行号
    ,otherlimitflag varchar2(2) -- 是否占用他用额度
    ,hxtyclassifylevel varchar2(4) -- 债项分类
    ,businesssumtypart number(24,6) -- 同业授信额度(元)
    ,authostrdate date -- 授权起始日
    ,bizlongestterm number(22) -- 额度下业务最长期限月)
    ,financialmodel varchar2(4000) -- 集群客户操作模式、风险管理及控制方案
    ,channelid varchar2(32) -- 通道方编号
    ,maxexposureamount number(24,6) -- 单一最高授信额度敞口金额
    ,changetype varchar2(4) -- 变更原因
    ,originalid varchar2(16) -- 原始权益人编号
    ,issuernameid varchar2(16) -- 发行人编号
    ,phaseopinion varchar2(32) -- 主动批量-授信方案意见
    ,finishflag varchar2(4) -- 主动批量-授信方案确认标志
    ,ispenetrate varchar2(2) -- 是否可穿透
    ,ifapprove varchar2(1) -- 是否人工填写标志
    ,afterpayreq varchar2(4000) -- 发放与支付前须落实的特殊限制性条件
    ,contractreq varchar2(4000) -- 需落实到合同、协议中的特殊要求
    ,islikelowrisk varchar2(2) -- 是否类低风险
    ,loanmanagereq varchar2(4000) -- 贷后管理要求
    ,payreq varchar2(4000) -- 授信方案
    ,focuslendtype varchar2(2) -- 集中放款业务类型
    ,isinnovate varchar2(2) -- 是否创新业务
    ,issupplychainfinance varchar2(2) -- 是否供应链金融业务
    ,isprojectfinancing varchar2(10) -- 是否项目融资
    ,custraterisklevel varchar2(20) -- 客户内评评级结果
    ,onlineapprovallimit number(24,6) -- 线上审批额度
    ,oastatus varchar2(3) -- OA审批状态
    ,isjoinlimits varchar2(2) -- 是否纳入单一客户或集团的限额
    ,otherlimitamount number(24,6) -- 他用额度占用金额
    ,proborrowerattr varchar2(10) -- 借款人属性
    ,proborrowerincome varchar2(10) -- 借款人收入特征
    ,proborrowerdebt varchar2(10) -- 借款人偿债特征
    ,proassetscontrol varchar2(10) -- 资产控制
    ,prorevenuecontrol varchar2(10) -- 收入控制
    ,projfinancingtype varchar2(10) -- 项目融资类型
    ,mercfinancingobject varchar2(10) -- 商品融资对象
    ,itemsfinancingtype varchar2(10) -- 物品融资类型
    ,isonlineapprove varchar2(2) -- 是否线上化审批
    ,guaranteecompanyname varchar2(64) -- 见保即贷业务担保公司
    ,runentyearincome number(24,6) -- 流水推算的年销售收入
    ,lastyearentyearincome number(24,6) -- 纳税申报资料反映的上年度收入
    ,yearincomerate varchar2(64) -- 预计销售收入年增长率
    ,operationloanbalanceskr number(24,6) -- 实控人经营性贷款余额
    ,otherworkcaptial number(24,6) -- 其他渠道提供的营运资金
    ,isrelatedcompany varchar2(2) -- 借款企业是否为担保公司的关联企业:1是0否
    ,subjectbusiness varchar2(4000) -- 主营业务
    ,enterpriseamt number(24,6) -- 借款企业在我行有效额度
    ,riskapproveamout number(24,6) -- 风控最终审批金额
    ,riskapprovestatus varchar2(12) -- 风控最终状态
    ,riskterm number(30) -- 风控最终审批期限
    ,isbranchbusiness varchar2(2) -- 是否分行权限内业务
    ,bondingcompanyinamt number(24,6) -- 意向担保金额
    ,guarcompanyterm number(22) -- 
    ,comptaxgrade varchar2(10) -- 企业纳税等级
    ,issignchange varchar2(2) -- 经营情况是否发生重大变化
    ,isothersignclassify varchar2(2) -- 是否存在其他重大风险
    ,batchcustomertype varchar2(10) -- 批量授信客户类型
    ,ishxdanbaoloan varchar2(10) -- 是否为华兴担保贷:1-是0-否
    ,enttermduedate date -- 企业营业期限到期日
    ,hxdanbaocustomername varchar2(200) -- 华兴担保贷担保公司名称
    ,hxdanbaocertid varchar2(60) -- 华兴担保贷担保公司证件号码
    ,scanstatus varchar2(10) -- 扫描任务状态(0-扫描中、1-扫描完成、2-撤销)
    ,actualenttype varchar2(4) -- 实际企业类型
    ,actualbusinesstype varchar2(4) -- 实际业务类型
    ,externalstatus varchar2(10) -- 外部数据状态
    ,externaldate date -- 外部数据日期
    ,baseproducttype varchar2(200) -- 基础资产类型
    ,baseproducttypeiscycle varchar2(32) -- 基础资产是否涉及循环购买
    ,customerprojectrole varchar2(2000) -- 受信人项目角色
    ,isautomanagelimit varchar2(32) -- 是否主动管理类额度
    ,customerproductrole varchar2(200) -- 受信人在产品中的角色
    ,dbinvesttermmonth varchar2(32) -- 单笔投资期限
    ,isbankbilldiscount varchar2(10) -- 是否银票贴现
    ,creditmodel varchar2(10) -- 额度类型
    ,actualbaseproducttype varchar2(4) -- 资产证券化业务子类
    ,isstateenttype varchar2(4) -- 是否国有企业标识(0否1是)
    ,iscityinvestbond varchar2(4) -- 是否城投债(0否1是)
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
grant select on ${iol_schema}.icms_ba_cl_info to ${iml_schema};
grant select on ${iol_schema}.icms_ba_cl_info to ${icl_schema};
grant select on ${iol_schema}.icms_ba_cl_info to ${idl_schema};
grant select on ${iol_schema}.icms_ba_cl_info to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_ba_cl_info is '业务申请额度属性表';
comment on column ${iol_schema}.icms_ba_cl_info.serialno is '流水号';
comment on column ${iol_schema}.icms_ba_cl_info.outclassifydate is '外部评级日期';
comment on column ${iol_schema}.icms_ba_cl_info.totalsumentpart is '公司敞口金额(元)';
comment on column ${iol_schema}.icms_ba_cl_info.dlcdbz is '代理参贷标志';
comment on column ${iol_schema}.icms_ba_cl_info.investtarget is '投资标的';
comment on column ${iol_schema}.icms_ba_cl_info.othercondition is '额度使用条件';
comment on column ${iol_schema}.icms_ba_cl_info.iscreditincrement is '是否有增信';
comment on column ${iol_schema}.icms_ba_cl_info.hxtymainratelevel is '外部主体评级';
comment on column ${iol_schema}.icms_ba_cl_info.migtflag is '迁移标志：CRS RCR ILC UPL';
comment on column ${iol_schema}.icms_ba_cl_info.channelname is '通道方名称';
comment on column ${iol_schema}.icms_ba_cl_info.isbillapply is '是否新增银承额度专项贴现';
comment on column ${iol_schema}.icms_ba_cl_info.refbankname is '参贷行行号';
comment on column ${iol_schema}.icms_ba_cl_info.isgovernfinance is '是否涉及政府类融资';
comment on column ${iol_schema}.icms_ba_cl_info.lngotimes is '借新还旧次数';
comment on column ${iol_schema}.icms_ba_cl_info.mainlevelorg is '主体评级机构';
comment on column ${iol_schema}.icms_ba_cl_info.singlebizmostamount is '额度下业务单笔最大金额';
comment on column ${iol_schema}.icms_ba_cl_info.riskexposuresum is '其中，一般风险敞口限额';
comment on column ${iol_schema}.icms_ba_cl_info.nominalsum is '额度名义金额';
comment on column ${iol_schema}.icms_ba_cl_info.isestatefinance is '是否涉及房地产融资';
comment on column ${iol_schema}.icms_ba_cl_info.bizextendedterm is '额度下业务延展期限月)';
comment on column ${iol_schema}.icms_ba_cl_info.availableexposuresum is '可用敞口金额';
comment on column ${iol_schema}.icms_ba_cl_info.islikeloan is '是否类信贷';
comment on column ${iol_schema}.icms_ba_cl_info.publishsum is '本次发行金额';
comment on column ${iol_schema}.icms_ba_cl_info.bizmostmortgagerate is '额度下业务最高抵质押率';
comment on column ${iol_schema}.icms_ba_cl_info.isfinancialcredit is '是否商圈授信';
comment on column ${iol_schema}.icms_ba_cl_info.investway is '投资方式';
comment on column ${iol_schema}.icms_ba_cl_info.fundsource is '资金来源';
comment on column ${iol_schema}.icms_ba_cl_info.playtype is '参与方式';
comment on column ${iol_schema}.icms_ba_cl_info.termtype is '期限申请类型额度)';
comment on column ${iol_schema}.icms_ba_cl_info.lineclass is '额度种类综合/专项/其他)';
comment on column ${iol_schema}.icms_ba_cl_info.suremodel is '是否总行认定模式';
comment on column ${iol_schema}.icms_ba_cl_info.managename is '管理人名称';
comment on column ${iol_schema}.icms_ba_cl_info.manageid is '管理人客户号';
comment on column ${iol_schema}.icms_ba_cl_info.istrans is '是否转授信';
comment on column ${iol_schema}.icms_ba_cl_info.belonggroupapproveno is '集团批复编号';
comment on column ${iol_schema}.icms_ba_cl_info.financialcreditowner is '集群客户专项额度所有人';
comment on column ${iol_schema}.icms_ba_cl_info.issmeandretail is '是否我行小微企业并且走零售条线';
comment on column ${iol_schema}.icms_ba_cl_info.originalname is '原始权益人名称';
comment on column ${iol_schema}.icms_ba_cl_info.ispubliccredit is '是否公开授信额度)';
comment on column ${iol_schema}.icms_ba_cl_info.occupynominalsum is '已用授信额度';
comment on column ${iol_schema}.icms_ba_cl_info.moneyindustryt is '资金投向行业';
comment on column ${iol_schema}.icms_ba_cl_info.bizbailinitialrate is '额度下业务初始保证金比例';
comment on column ${iol_schema}.icms_ba_cl_info.transcount is '交易对手个数';
comment on column ${iol_schema}.icms_ba_cl_info.maxnominalamount is '单一最高授信额度名义金额';
comment on column ${iol_schema}.icms_ba_cl_info.lowriskexposuresum is '其中，类低风险敞口金额(元)';
comment on column ${iol_schema}.icms_ba_cl_info.bizlowestfloatrate is '额度下业务利率最低浮动';
comment on column ${iol_schema}.icms_ba_cl_info.occupyexposuresum is '已用敞口金额自动计算)';
comment on column ${iol_schema}.icms_ba_cl_info.totalsumtypart is '同业敞口金额(元)';
comment on column ${iol_schema}.icms_ba_cl_info.linecontrolmode is '集团额度管控模式超额分配/全额分配)';
comment on column ${iol_schema}.icms_ba_cl_info.latestusedate is '额度最迟使用日期';
comment on column ${iol_schema}.icms_ba_cl_info.isgreenfinance is '是否为绿色信贷融资';
comment on column ${iol_schema}.icms_ba_cl_info.otherlimitownerid is '他用额度所有人';
comment on column ${iol_schema}.icms_ba_cl_info.availablenominalsum is '可用名义金额';
comment on column ${iol_schema}.icms_ba_cl_info.hostbankname is '主办行行名';
comment on column ${iol_schema}.icms_ba_cl_info.authvouchtype is '授权权限_担保方式';
comment on column ${iol_schema}.icms_ba_cl_info.isquerycreditreport is '是否自动查询贷后报告';
comment on column ${iol_schema}.icms_ba_cl_info.mainleveldate is '主体评级日期';
comment on column ${iol_schema}.icms_ba_cl_info.usewithoutcondition is '能否直接使用额度)';
comment on column ${iol_schema}.icms_ba_cl_info.isbeltroadfinance is '是否为一带一路建设投融资';
comment on column ${iol_schema}.icms_ba_cl_info.otherlimittype is '他用额度类型';
comment on column ${iol_schema}.icms_ba_cl_info.sqdkze is '申请银团贷款总额(元)';
comment on column ${iol_schema}.icms_ba_cl_info.outclassifylevel is '外部债项评级';
comment on column ${iol_schema}.icms_ba_cl_info.jxhjcontractno is '借新还旧原合同';
comment on column ${iol_schema}.icms_ba_cl_info.businesssumentpart is '公司授信额度(元)';
comment on column ${iol_schema}.icms_ba_cl_info.currencyrange is '项下业务币种范围';
comment on column ${iol_schema}.icms_ba_cl_info.isconsumerfinance is '是否为消费服务类融资';
comment on column ${iol_schema}.icms_ba_cl_info.drtimes is '债务重组次数';
comment on column ${iol_schema}.icms_ba_cl_info.exposuresum is '额度敞口金额';
comment on column ${iol_schema}.icms_ba_cl_info.classifyresulteleven is '债项分类';
comment on column ${iol_schema}.icms_ba_cl_info.issuername is '发行人名称';
comment on column ${iol_schema}.icms_ba_cl_info.financialcreditserialno is '集群客户专项额度流水号';
comment on column ${iol_schema}.icms_ba_cl_info.hxtyoperateorg is '归口管理部门';
comment on column ${iol_schema}.icms_ba_cl_info.issme is '是否小微企业贷款';
comment on column ${iol_schema}.icms_ba_cl_info.hostbankno is '主办行行号';
comment on column ${iol_schema}.icms_ba_cl_info.agentbankname is '代理行行号';
comment on column ${iol_schema}.icms_ba_cl_info.otherlimitno is '他用额度流水号';
comment on column ${iol_schema}.icms_ba_cl_info.creditauthno is '征信授权影像流水号';
comment on column ${iol_schema}.icms_ba_cl_info.agentbankno is '代理行行号';
comment on column ${iol_schema}.icms_ba_cl_info.approvepubsum is '批准发行总额';
comment on column ${iol_schema}.icms_ba_cl_info.outclassifyorg is '外部评级机构名称';
comment on column ${iol_schema}.icms_ba_cl_info.creditarea is '授信区域';
comment on column ${iol_schema}.icms_ba_cl_info.publicorg is '发行场所';
comment on column ${iol_schema}.icms_ba_cl_info.isyhcustomer is '是否优合授信客户';
comment on column ${iol_schema}.icms_ba_cl_info.onlineamount is '线上额度(元)';
comment on column ${iol_schema}.icms_ba_cl_info.refbankno is '参贷行行号';
comment on column ${iol_schema}.icms_ba_cl_info.otherlimitflag is '是否占用他用额度';
comment on column ${iol_schema}.icms_ba_cl_info.hxtyclassifylevel is '债项分类';
comment on column ${iol_schema}.icms_ba_cl_info.businesssumtypart is '同业授信额度(元)';
comment on column ${iol_schema}.icms_ba_cl_info.authostrdate is '授权起始日';
comment on column ${iol_schema}.icms_ba_cl_info.bizlongestterm is '额度下业务最长期限月)';
comment on column ${iol_schema}.icms_ba_cl_info.financialmodel is '集群客户操作模式、风险管理及控制方案';
comment on column ${iol_schema}.icms_ba_cl_info.channelid is '通道方编号';
comment on column ${iol_schema}.icms_ba_cl_info.maxexposureamount is '单一最高授信额度敞口金额';
comment on column ${iol_schema}.icms_ba_cl_info.changetype is '变更原因';
comment on column ${iol_schema}.icms_ba_cl_info.originalid is '原始权益人编号';
comment on column ${iol_schema}.icms_ba_cl_info.issuernameid is '发行人编号';
comment on column ${iol_schema}.icms_ba_cl_info.phaseopinion is '主动批量-授信方案意见';
comment on column ${iol_schema}.icms_ba_cl_info.finishflag is '主动批量-授信方案确认标志';
comment on column ${iol_schema}.icms_ba_cl_info.ispenetrate is '是否可穿透';
comment on column ${iol_schema}.icms_ba_cl_info.ifapprove is '是否人工填写标志';
comment on column ${iol_schema}.icms_ba_cl_info.afterpayreq is '发放与支付前须落实的特殊限制性条件';
comment on column ${iol_schema}.icms_ba_cl_info.contractreq is '需落实到合同、协议中的特殊要求';
comment on column ${iol_schema}.icms_ba_cl_info.islikelowrisk is '是否类低风险';
comment on column ${iol_schema}.icms_ba_cl_info.loanmanagereq is '贷后管理要求';
comment on column ${iol_schema}.icms_ba_cl_info.payreq is '授信方案';
comment on column ${iol_schema}.icms_ba_cl_info.focuslendtype is '集中放款业务类型';
comment on column ${iol_schema}.icms_ba_cl_info.isinnovate is '是否创新业务';
comment on column ${iol_schema}.icms_ba_cl_info.issupplychainfinance is '是否供应链金融业务';
comment on column ${iol_schema}.icms_ba_cl_info.isprojectfinancing is '是否项目融资';
comment on column ${iol_schema}.icms_ba_cl_info.custraterisklevel is '客户内评评级结果';
comment on column ${iol_schema}.icms_ba_cl_info.onlineapprovallimit is '线上审批额度';
comment on column ${iol_schema}.icms_ba_cl_info.oastatus is 'OA审批状态';
comment on column ${iol_schema}.icms_ba_cl_info.isjoinlimits is '是否纳入单一客户或集团的限额';
comment on column ${iol_schema}.icms_ba_cl_info.otherlimitamount is '他用额度占用金额';
comment on column ${iol_schema}.icms_ba_cl_info.proborrowerattr is '借款人属性';
comment on column ${iol_schema}.icms_ba_cl_info.proborrowerincome is '借款人收入特征';
comment on column ${iol_schema}.icms_ba_cl_info.proborrowerdebt is '借款人偿债特征';
comment on column ${iol_schema}.icms_ba_cl_info.proassetscontrol is '资产控制';
comment on column ${iol_schema}.icms_ba_cl_info.prorevenuecontrol is '收入控制';
comment on column ${iol_schema}.icms_ba_cl_info.projfinancingtype is '项目融资类型';
comment on column ${iol_schema}.icms_ba_cl_info.mercfinancingobject is '商品融资对象';
comment on column ${iol_schema}.icms_ba_cl_info.itemsfinancingtype is '物品融资类型';
comment on column ${iol_schema}.icms_ba_cl_info.isonlineapprove is '是否线上化审批';
comment on column ${iol_schema}.icms_ba_cl_info.guaranteecompanyname is '见保即贷业务担保公司';
comment on column ${iol_schema}.icms_ba_cl_info.runentyearincome is '流水推算的年销售收入';
comment on column ${iol_schema}.icms_ba_cl_info.lastyearentyearincome is '纳税申报资料反映的上年度收入';
comment on column ${iol_schema}.icms_ba_cl_info.yearincomerate is '预计销售收入年增长率';
comment on column ${iol_schema}.icms_ba_cl_info.operationloanbalanceskr is '实控人经营性贷款余额';
comment on column ${iol_schema}.icms_ba_cl_info.otherworkcaptial is '其他渠道提供的营运资金';
comment on column ${iol_schema}.icms_ba_cl_info.isrelatedcompany is '借款企业是否为担保公司的关联企业:1是0否';
comment on column ${iol_schema}.icms_ba_cl_info.subjectbusiness is '主营业务';
comment on column ${iol_schema}.icms_ba_cl_info.enterpriseamt is '借款企业在我行有效额度';
comment on column ${iol_schema}.icms_ba_cl_info.riskapproveamout is '风控最终审批金额';
comment on column ${iol_schema}.icms_ba_cl_info.riskapprovestatus is '风控最终状态';
comment on column ${iol_schema}.icms_ba_cl_info.riskterm is '风控最终审批期限';
comment on column ${iol_schema}.icms_ba_cl_info.isbranchbusiness is '是否分行权限内业务';
comment on column ${iol_schema}.icms_ba_cl_info.bondingcompanyinamt is '意向担保金额';
comment on column ${iol_schema}.icms_ba_cl_info.guarcompanyterm is '担保公司推送期限';
comment on column ${iol_schema}.icms_ba_cl_info.comptaxgrade is '企业纳税等级';
comment on column ${iol_schema}.icms_ba_cl_info.issignchange is '经营情况是否发生重大变化';
comment on column ${iol_schema}.icms_ba_cl_info.isothersignclassify is '是否存在其他重大风险';
comment on column ${iol_schema}.icms_ba_cl_info.batchcustomertype is '批量授信客户类型';
comment on column ${iol_schema}.icms_ba_cl_info.ishxdanbaoloan is '是否为华兴担保贷:1-是0-否';
comment on column ${iol_schema}.icms_ba_cl_info.enttermduedate is '企业营业期限到期日';
comment on column ${iol_schema}.icms_ba_cl_info.hxdanbaocustomername is '华兴担保贷担保公司名称';
comment on column ${iol_schema}.icms_ba_cl_info.hxdanbaocertid is '华兴担保贷担保公司证件号码';
comment on column ${iol_schema}.icms_ba_cl_info.scanstatus is '扫描任务状态(0-扫描中、1-扫描完成、2-撤销)';
comment on column ${iol_schema}.icms_ba_cl_info.actualenttype is '实际企业类型';
comment on column ${iol_schema}.icms_ba_cl_info.actualbusinesstype is '实际业务类型';
comment on column ${iol_schema}.icms_ba_cl_info.externalstatus is '外部数据状态';
comment on column ${iol_schema}.icms_ba_cl_info.externaldate is '外部数据日期';
comment on column ${iol_schema}.icms_ba_cl_info.baseproducttype is '基础资产类型';
comment on column ${iol_schema}.icms_ba_cl_info.baseproducttypeiscycle is '基础资产是否涉及循环购买';
comment on column ${iol_schema}.icms_ba_cl_info.customerprojectrole is '受信人项目角色';
comment on column ${iol_schema}.icms_ba_cl_info.isautomanagelimit is '是否主动管理类额度';
comment on column ${iol_schema}.icms_ba_cl_info.customerproductrole is '受信人在产品中的角色';
comment on column ${iol_schema}.icms_ba_cl_info.dbinvesttermmonth is '单笔投资期限';
comment on column ${iol_schema}.icms_ba_cl_info.isbankbilldiscount is '是否银票贴现';
comment on column ${iol_schema}.icms_ba_cl_info.creditmodel is '额度类型';
comment on column ${iol_schema}.icms_ba_cl_info.actualbaseproducttype is '资产证券化业务子类';
comment on column ${iol_schema}.icms_ba_cl_info.isstateenttype is '是否国有企业标识(0否1是)';
comment on column ${iol_schema}.icms_ba_cl_info.iscityinvestbond is '是否城投债(0否1是)';
comment on column ${iol_schema}.icms_ba_cl_info.start_dt is '开始时间';
comment on column ${iol_schema}.icms_ba_cl_info.end_dt is '结束时间';
comment on column ${iol_schema}.icms_ba_cl_info.id_mark is '增删标志';
comment on column ${iol_schema}.icms_ba_cl_info.etl_timestamp is 'ETL处理时间戳';
