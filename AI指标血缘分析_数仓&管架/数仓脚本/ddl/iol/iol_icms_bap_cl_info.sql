/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_bap_cl_info
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_bap_cl_info
whenever sqlerror continue none;
drop table ${iol_schema}.icms_bap_cl_info purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_bap_cl_info(
    serialno varchar2(32) -- 流水号
    ,refbankname varchar2(200) -- 参贷行行号
    ,agentbankname varchar2(200) -- 代理行行号
    ,linecontrolmode varchar2(18) -- 集团额度管控模式超额分配/全额分配)
    ,nominalsum number(24,6) -- 额度名义金额
    ,landusecertid varchar2(200) -- 国有土地使用证号
    ,thirdpartyzip1 varchar2(32) -- 公积金贷款手续费比例%
    ,outclassifyorg varchar2(200) -- 外部评级机构
    ,creditarea varchar2(2) -- 授信区域
    ,isbillapply varchar2(10) -- 是否新增银承额度专项贴现
    ,hostbankno varchar2(16) -- 主办行行号
    ,bizmostmortgagerate number(10,6) -- 额度下业务最高抵质押率
    ,totalsumtypart number(24,6) -- 同业敞口金额(元)
    ,businesssumentpart number(24,6) -- 公司额度金额(元)
    ,mainlevelorg varchar2(200) -- 主体评级机构
    ,otherlimittype varchar2(32) -- 他用额度类型
    ,approveopinion varchar2(4000) -- 最终审批意见
    ,describe2 varchar2(200) -- 项目座落位置
    ,fundsource varchar2(36) -- 资金来源
    ,bizlongestterm number(22) -- 额度下业务最长期限月)
    ,occupynominalsum number(24,6) -- 已用名义金额自动计算)
    ,belonggroupapproveno varchar2(32) -- 集团批复编号
    ,lngotimes number(22) -- 借新还旧次数
    ,playtype varchar2(2) -- 参与方式
    ,flag1 varchar2(18) -- 是否为项下业务提供保证担保
    ,investway varchar2(2) -- 投资方式
    ,hxtyoperateorg varchar2(2) -- 归口管理部门
    ,isfinancialcredit varchar2(80) -- 是否商圈授信
    ,sqdkze number(18,2) -- 申请银团贷款总额(元)
    ,constructionarea number(24,6) -- 项目总面积（平方米）
    ,financialmodel varchar2(4000) -- 集群客户操作模式、风险管理及控制方案
    ,drtimes number(22) -- 债务重组次数
    ,usewithoutcondition varchar2(1) -- 能否直接使用额度)
    ,othercondition varchar2(4000) -- 额度使用条件\集群客户授信方案
    ,creditauthno varchar2(40) -- 征信授权影像流水号
    ,manageid varchar2(16) -- 管理人客户号
    ,istrans varchar2(2) -- 是否转授信
    ,bizbailinitialrate number(24,8) -- 额度下业务初始保证金比例
    ,rateopinion varchar2(18) -- 客户评级
    ,hxtyclassifylevel varchar2(2) -- 债项分类
    ,lineclass varchar2(18) -- 额度种类综合/专项/其他)
    ,refbankno varchar2(16) -- 参贷行行号
    ,thirdpartyid1 varchar2(50) -- 建设用地规划可证号
    ,thirdpartyid2 varchar2(40) -- 建设工程规划许可证号
    ,maxexposureamount number(24,6) -- 单一最高授信额度敞口金额
    ,termtype varchar2(18) -- 期限申请类型额度)
    ,outclassifydate varchar2(10) -- 外部评级日期
    ,iscreditincrement varchar2(2) -- 是否有增信
    ,dlcdbz varchar2(1) -- 代理参贷标志
    ,publishsum number(24,6) -- 本次发行金额
    ,availablenominalsum number(24,6) -- 可用名义金额
    ,availableexposuresum number(24,6) -- 可用敞口金额
    ,otherlimitno varchar2(32) -- 他用额度流水号
    ,totalsumentpart number(24,6) -- 公司敞口金额(元)
    ,isconsumerfinance varchar2(2) -- 是否为消费服务类融资
    ,agentbankno varchar2(16) -- 代理行行号
    ,occupyexposuresum number(24,6) -- 已用敞口金额自动计算)
    ,otherlimitownerid varchar2(32) -- 他用额度所有人
    ,thirdparty1 varchar2(200) -- 销(预)售许可证号
    ,issmeandretail varchar2(1) -- 是否我行小微企业并且走零售条线
    ,issme varchar2(1) -- 是否小微企业贷款
    ,maxnominalamount number(24,6) -- 单一最高授信额度名义金额
    ,bizextendedterm number(22) -- 额度下业务延展期限月)
    ,otherlimitflag varchar2(2) -- 是否占用他用额度
    ,bizlowestfloatrate number(24,8) -- 额度下业务利率最低浮动
    ,currencyrange varchar2(200) -- 项下业务币种范围
    ,isquerycreditreport varchar2(10) -- 是否自动查询贷后报告
    ,isyeartocheck varchar2(4) -- 是否需要年审
    ,isgreenfinance varchar2(2) -- 是否为绿色信贷融资
    ,outclassifylevel varchar2(18) -- 外部债项评级
    ,investtarget varchar2(500) -- 投资标的
    ,approvepubsum number(24,6) -- 批准发行总额
    ,financialcreditserialno varchar2(32) -- 集群客户专项额度流水号
    ,bailratio number(10,6) -- 保证金比例%
    ,bailsum number(24,6) -- 保证金金额（元）
    ,transcount varchar2(2) -- 交易对手个数
    ,hxtymainratelevel varchar2(18) -- 外部主体评级
    ,businesssumtypart number(24,6) -- 同业额度金额(元)
    ,islikeloan varchar2(2) -- 是否类信贷
    ,authvouchtype varchar2(18) -- 授权权限_担保方式
    ,approveopinion6 varchar2(4000) -- 贷后要求
    ,projectname varchar2(80) -- 项目名称
    ,publicorg varchar2(2) -- 发行场所
    ,termday number(22) -- 零（天）
    ,thirdpartyid3 varchar2(32) -- 最高成数%
    ,migtflag varchar2(80) -- 
    ,thirdpartyadd1 varchar2(80) -- 最长期限(年)
    ,isestatefinance varchar2(2) -- 是否涉及房地产融资
    ,financialcreditowner varchar2(80) -- 集群客户专项额度所有人
    ,approveopinion1 varchar2(4000) -- 最终审批意见2
    ,approvedate date -- 批复日期
    ,isyhcustomer varchar2(10) -- 是否优合授信客户
    ,exposuresum number(24,6) -- 额度敞口金额
    ,sqcheckyeardate date -- 上期年审日期
    ,describe1 varchar2(200) -- 项下业务主要担保方式
    ,thirdparty3 varchar2(200) -- 建筑工程施工可证号
    ,hostbankname varchar2(200) -- 主办行行名
    ,singlebizmostamount number(24,6) -- 额度下业务单笔最大金额
    ,suremodel varchar2(2) -- 是否总行认定模式
    ,managename varchar2(100) -- 管理人名称
    ,ispubliccredit varchar2(1) -- 是否公开授信额度)
    ,latestusedate date -- 额度最迟使用日期
    ,flag2 varchar2(18) -- 是否为项下业务承担回购责任
    ,gurantymonth number(22) -- 担保期限(月)
    ,isgovernfinance varchar2(2) -- 是否涉及政府类融资
    ,approveopinion7 varchar2(4000) -- 贷后要求补充说明
    ,bqcheckyeardate date -- 本期年审日期
    ,onlineamount number(24,6) -- 线上额度(元)
    ,isbeltroadfinance varchar2(2) -- 是否为一带一路建设投融资
    ,riskexposuresum number(24,6) -- 其中，一般风险敞口限额
    ,mainleveldate varchar2(10) -- 主体评级日期
    ,noeffectreason varchar2(4) -- 失效原因
    ,changetype varchar2(4) -- 变更原因
    ,phaseopinion varchar2(32) -- 主动批量-授信方案意见
    ,finishflag varchar2(4) -- 主动批量-授信方案确认标志
    ,ifapprove varchar2(1) -- 是否人工填写标志
    ,lowriskexposuresum number(24,6) -- 其中，类低风险敞口金额(元)
    ,afterpayreq varchar2(4000) -- 发放与支付前须落实的特殊限制性条件
    ,contractreq varchar2(4000) -- 需落实到合同、协议中的特殊要求
    ,custraterisklevel varchar2(20) -- 客户内评评级结果
    ,islikelowrisk varchar2(2) -- 是否类低风险
    ,loanmanagereq varchar2(4000) -- 贷后管理要求
    ,payreq varchar2(4000) -- 授信方案
    ,focuslendtype varchar2(2) -- 集中放款业务类型
    ,isinnovate varchar2(2) -- 是否创新业务
    ,issupplychainfinance varchar2(2) -- 是否供应链金融业务
    ,isjoinlimits varchar2(2) -- 
    ,otherlimitamount number(24,6) -- 
    ,iscollectionagency varchar2(2) -- 
    ,antimoneylaunderlevel varchar2(32) -- 
    ,islimit varchar2(2) -- 
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
grant select on ${iol_schema}.icms_bap_cl_info to ${iml_schema};
grant select on ${iol_schema}.icms_bap_cl_info to ${icl_schema};
grant select on ${iol_schema}.icms_bap_cl_info to ${idl_schema};
grant select on ${iol_schema}.icms_bap_cl_info to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_bap_cl_info is '业务批复额度属性表';
comment on column ${iol_schema}.icms_bap_cl_info.serialno is '流水号';
comment on column ${iol_schema}.icms_bap_cl_info.refbankname is '参贷行行号';
comment on column ${iol_schema}.icms_bap_cl_info.agentbankname is '代理行行号';
comment on column ${iol_schema}.icms_bap_cl_info.linecontrolmode is '集团额度管控模式超额分配/全额分配)';
comment on column ${iol_schema}.icms_bap_cl_info.nominalsum is '额度名义金额';
comment on column ${iol_schema}.icms_bap_cl_info.landusecertid is '国有土地使用证号';
comment on column ${iol_schema}.icms_bap_cl_info.thirdpartyzip1 is '公积金贷款手续费比例%';
comment on column ${iol_schema}.icms_bap_cl_info.outclassifyorg is '外部评级机构';
comment on column ${iol_schema}.icms_bap_cl_info.creditarea is '授信区域';
comment on column ${iol_schema}.icms_bap_cl_info.isbillapply is '是否新增银承额度专项贴现';
comment on column ${iol_schema}.icms_bap_cl_info.hostbankno is '主办行行号';
comment on column ${iol_schema}.icms_bap_cl_info.bizmostmortgagerate is '额度下业务最高抵质押率';
comment on column ${iol_schema}.icms_bap_cl_info.totalsumtypart is '同业敞口金额(元)';
comment on column ${iol_schema}.icms_bap_cl_info.businesssumentpart is '公司额度金额(元)';
comment on column ${iol_schema}.icms_bap_cl_info.mainlevelorg is '主体评级机构';
comment on column ${iol_schema}.icms_bap_cl_info.otherlimittype is '他用额度类型';
comment on column ${iol_schema}.icms_bap_cl_info.approveopinion is '最终审批意见';
comment on column ${iol_schema}.icms_bap_cl_info.describe2 is '项目座落位置';
comment on column ${iol_schema}.icms_bap_cl_info.fundsource is '资金来源';
comment on column ${iol_schema}.icms_bap_cl_info.bizlongestterm is '额度下业务最长期限月)';
comment on column ${iol_schema}.icms_bap_cl_info.occupynominalsum is '已用名义金额自动计算)';
comment on column ${iol_schema}.icms_bap_cl_info.belonggroupapproveno is '集团批复编号';
comment on column ${iol_schema}.icms_bap_cl_info.lngotimes is '借新还旧次数';
comment on column ${iol_schema}.icms_bap_cl_info.playtype is '参与方式';
comment on column ${iol_schema}.icms_bap_cl_info.flag1 is '是否为项下业务提供保证担保';
comment on column ${iol_schema}.icms_bap_cl_info.investway is '投资方式';
comment on column ${iol_schema}.icms_bap_cl_info.hxtyoperateorg is '归口管理部门';
comment on column ${iol_schema}.icms_bap_cl_info.isfinancialcredit is '是否商圈授信';
comment on column ${iol_schema}.icms_bap_cl_info.sqdkze is '申请银团贷款总额(元)';
comment on column ${iol_schema}.icms_bap_cl_info.constructionarea is '项目总面积（平方米）';
comment on column ${iol_schema}.icms_bap_cl_info.financialmodel is '集群客户操作模式、风险管理及控制方案';
comment on column ${iol_schema}.icms_bap_cl_info.drtimes is '债务重组次数';
comment on column ${iol_schema}.icms_bap_cl_info.usewithoutcondition is '能否直接使用额度)';
comment on column ${iol_schema}.icms_bap_cl_info.othercondition is '额度使用条件\集群客户授信方案';
comment on column ${iol_schema}.icms_bap_cl_info.creditauthno is '征信授权影像流水号';
comment on column ${iol_schema}.icms_bap_cl_info.manageid is '管理人客户号';
comment on column ${iol_schema}.icms_bap_cl_info.istrans is '是否转授信';
comment on column ${iol_schema}.icms_bap_cl_info.bizbailinitialrate is '额度下业务初始保证金比例';
comment on column ${iol_schema}.icms_bap_cl_info.rateopinion is '客户评级';
comment on column ${iol_schema}.icms_bap_cl_info.hxtyclassifylevel is '债项分类';
comment on column ${iol_schema}.icms_bap_cl_info.lineclass is '额度种类综合/专项/其他)';
comment on column ${iol_schema}.icms_bap_cl_info.refbankno is '参贷行行号';
comment on column ${iol_schema}.icms_bap_cl_info.thirdpartyid1 is '建设用地规划可证号';
comment on column ${iol_schema}.icms_bap_cl_info.thirdpartyid2 is '建设工程规划许可证号';
comment on column ${iol_schema}.icms_bap_cl_info.maxexposureamount is '单一最高授信额度敞口金额';
comment on column ${iol_schema}.icms_bap_cl_info.termtype is '期限申请类型额度)';
comment on column ${iol_schema}.icms_bap_cl_info.outclassifydate is '外部评级日期';
comment on column ${iol_schema}.icms_bap_cl_info.iscreditincrement is '是否有增信';
comment on column ${iol_schema}.icms_bap_cl_info.dlcdbz is '代理参贷标志';
comment on column ${iol_schema}.icms_bap_cl_info.publishsum is '本次发行金额';
comment on column ${iol_schema}.icms_bap_cl_info.availablenominalsum is '可用名义金额';
comment on column ${iol_schema}.icms_bap_cl_info.availableexposuresum is '可用敞口金额';
comment on column ${iol_schema}.icms_bap_cl_info.otherlimitno is '他用额度流水号';
comment on column ${iol_schema}.icms_bap_cl_info.totalsumentpart is '公司敞口金额(元)';
comment on column ${iol_schema}.icms_bap_cl_info.isconsumerfinance is '是否为消费服务类融资';
comment on column ${iol_schema}.icms_bap_cl_info.agentbankno is '代理行行号';
comment on column ${iol_schema}.icms_bap_cl_info.occupyexposuresum is '已用敞口金额自动计算)';
comment on column ${iol_schema}.icms_bap_cl_info.otherlimitownerid is '他用额度所有人';
comment on column ${iol_schema}.icms_bap_cl_info.thirdparty1 is '销(预)售许可证号';
comment on column ${iol_schema}.icms_bap_cl_info.issmeandretail is '是否我行小微企业并且走零售条线';
comment on column ${iol_schema}.icms_bap_cl_info.issme is '是否小微企业贷款';
comment on column ${iol_schema}.icms_bap_cl_info.maxnominalamount is '单一最高授信额度名义金额';
comment on column ${iol_schema}.icms_bap_cl_info.bizextendedterm is '额度下业务延展期限月)';
comment on column ${iol_schema}.icms_bap_cl_info.otherlimitflag is '是否占用他用额度';
comment on column ${iol_schema}.icms_bap_cl_info.bizlowestfloatrate is '额度下业务利率最低浮动';
comment on column ${iol_schema}.icms_bap_cl_info.currencyrange is '项下业务币种范围';
comment on column ${iol_schema}.icms_bap_cl_info.isquerycreditreport is '是否自动查询贷后报告';
comment on column ${iol_schema}.icms_bap_cl_info.isyeartocheck is '是否需要年审';
comment on column ${iol_schema}.icms_bap_cl_info.isgreenfinance is '是否为绿色信贷融资';
comment on column ${iol_schema}.icms_bap_cl_info.outclassifylevel is '外部债项评级';
comment on column ${iol_schema}.icms_bap_cl_info.investtarget is '投资标的';
comment on column ${iol_schema}.icms_bap_cl_info.approvepubsum is '批准发行总额';
comment on column ${iol_schema}.icms_bap_cl_info.financialcreditserialno is '集群客户专项额度流水号';
comment on column ${iol_schema}.icms_bap_cl_info.bailratio is '保证金比例%';
comment on column ${iol_schema}.icms_bap_cl_info.bailsum is '保证金金额（元）';
comment on column ${iol_schema}.icms_bap_cl_info.transcount is '交易对手个数';
comment on column ${iol_schema}.icms_bap_cl_info.hxtymainratelevel is '外部主体评级';
comment on column ${iol_schema}.icms_bap_cl_info.businesssumtypart is '同业额度金额(元)';
comment on column ${iol_schema}.icms_bap_cl_info.islikeloan is '是否类信贷';
comment on column ${iol_schema}.icms_bap_cl_info.authvouchtype is '授权权限_担保方式';
comment on column ${iol_schema}.icms_bap_cl_info.approveopinion6 is '贷后要求';
comment on column ${iol_schema}.icms_bap_cl_info.projectname is '项目名称';
comment on column ${iol_schema}.icms_bap_cl_info.publicorg is '发行场所';
comment on column ${iol_schema}.icms_bap_cl_info.termday is '零（天）';
comment on column ${iol_schema}.icms_bap_cl_info.thirdpartyid3 is '最高成数%';
comment on column ${iol_schema}.icms_bap_cl_info.migtflag is '';
comment on column ${iol_schema}.icms_bap_cl_info.thirdpartyadd1 is '最长期限(年)';
comment on column ${iol_schema}.icms_bap_cl_info.isestatefinance is '是否涉及房地产融资';
comment on column ${iol_schema}.icms_bap_cl_info.financialcreditowner is '集群客户专项额度所有人';
comment on column ${iol_schema}.icms_bap_cl_info.approveopinion1 is '最终审批意见2';
comment on column ${iol_schema}.icms_bap_cl_info.approvedate is '批复日期';
comment on column ${iol_schema}.icms_bap_cl_info.isyhcustomer is '是否优合授信客户';
comment on column ${iol_schema}.icms_bap_cl_info.exposuresum is '额度敞口金额';
comment on column ${iol_schema}.icms_bap_cl_info.sqcheckyeardate is '上期年审日期';
comment on column ${iol_schema}.icms_bap_cl_info.describe1 is '项下业务主要担保方式';
comment on column ${iol_schema}.icms_bap_cl_info.thirdparty3 is '建筑工程施工可证号';
comment on column ${iol_schema}.icms_bap_cl_info.hostbankname is '主办行行名';
comment on column ${iol_schema}.icms_bap_cl_info.singlebizmostamount is '额度下业务单笔最大金额';
comment on column ${iol_schema}.icms_bap_cl_info.suremodel is '是否总行认定模式';
comment on column ${iol_schema}.icms_bap_cl_info.managename is '管理人名称';
comment on column ${iol_schema}.icms_bap_cl_info.ispubliccredit is '是否公开授信额度)';
comment on column ${iol_schema}.icms_bap_cl_info.latestusedate is '额度最迟使用日期';
comment on column ${iol_schema}.icms_bap_cl_info.flag2 is '是否为项下业务承担回购责任';
comment on column ${iol_schema}.icms_bap_cl_info.gurantymonth is '担保期限(月)';
comment on column ${iol_schema}.icms_bap_cl_info.isgovernfinance is '是否涉及政府类融资';
comment on column ${iol_schema}.icms_bap_cl_info.approveopinion7 is '贷后要求补充说明';
comment on column ${iol_schema}.icms_bap_cl_info.bqcheckyeardate is '本期年审日期';
comment on column ${iol_schema}.icms_bap_cl_info.onlineamount is '线上额度(元)';
comment on column ${iol_schema}.icms_bap_cl_info.isbeltroadfinance is '是否为一带一路建设投融资';
comment on column ${iol_schema}.icms_bap_cl_info.riskexposuresum is '其中，一般风险敞口限额';
comment on column ${iol_schema}.icms_bap_cl_info.mainleveldate is '主体评级日期';
comment on column ${iol_schema}.icms_bap_cl_info.noeffectreason is '失效原因';
comment on column ${iol_schema}.icms_bap_cl_info.changetype is '变更原因';
comment on column ${iol_schema}.icms_bap_cl_info.phaseopinion is '主动批量-授信方案意见';
comment on column ${iol_schema}.icms_bap_cl_info.finishflag is '主动批量-授信方案确认标志';
comment on column ${iol_schema}.icms_bap_cl_info.ifapprove is '是否人工填写标志';
comment on column ${iol_schema}.icms_bap_cl_info.lowriskexposuresum is '其中，类低风险敞口金额(元)';
comment on column ${iol_schema}.icms_bap_cl_info.afterpayreq is '发放与支付前须落实的特殊限制性条件';
comment on column ${iol_schema}.icms_bap_cl_info.contractreq is '需落实到合同、协议中的特殊要求';
comment on column ${iol_schema}.icms_bap_cl_info.custraterisklevel is '客户内评评级结果';
comment on column ${iol_schema}.icms_bap_cl_info.islikelowrisk is '是否类低风险';
comment on column ${iol_schema}.icms_bap_cl_info.loanmanagereq is '贷后管理要求';
comment on column ${iol_schema}.icms_bap_cl_info.payreq is '授信方案';
comment on column ${iol_schema}.icms_bap_cl_info.focuslendtype is '集中放款业务类型';
comment on column ${iol_schema}.icms_bap_cl_info.isinnovate is '是否创新业务';
comment on column ${iol_schema}.icms_bap_cl_info.issupplychainfinance is '是否供应链金融业务';
comment on column ${iol_schema}.icms_bap_cl_info.isjoinlimits is '';
comment on column ${iol_schema}.icms_bap_cl_info.otherlimitamount is '';
comment on column ${iol_schema}.icms_bap_cl_info.iscollectionagency is '';
comment on column ${iol_schema}.icms_bap_cl_info.antimoneylaunderlevel is '';
comment on column ${iol_schema}.icms_bap_cl_info.islimit is '';
comment on column ${iol_schema}.icms_bap_cl_info.start_dt is '开始时间';
comment on column ${iol_schema}.icms_bap_cl_info.end_dt is '结束时间';
comment on column ${iol_schema}.icms_bap_cl_info.id_mark is '增删标志';
comment on column ${iol_schema}.icms_bap_cl_info.etl_timestamp is 'ETL处理时间戳';
