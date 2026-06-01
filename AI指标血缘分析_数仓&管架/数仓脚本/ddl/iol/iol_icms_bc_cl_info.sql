/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_bc_cl_info
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_bc_cl_info
whenever sqlerror continue none;
drop table ${iol_schema}.icms_bc_cl_info purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_bc_cl_info(
    serialno varchar2(64) -- 流水号
    ,lineclass varchar2(36) -- 额度种类综合/专项/其他)
    ,currencyrange varchar2(400) -- 项下业务币种范围
    ,lngotimes number(22) -- 借新还旧次数
    ,occupynominalsum number(24,6) -- 已用名义金额自动计算)
    ,afterloanuserid varchar2(32) -- 贷后管理人员
    ,creditflowtype varchar2(20) -- 授信业务流程类型
    ,creditarea varchar2(2) -- 授信区域
    ,approvalsuggestion varchar2(32) -- 建议审批等级
    ,useterm date -- 额度项下业务最迟到期日期
    ,freezeflag varchar2(1) -- 冻结标志
    ,bizlongestterm number(22) -- 额度下业务最长期限月)
    ,occupyexposuresum number(24,6) -- 已用敞口金额自动计算)
    ,limitusecondition varchar2(4000) -- 额度使用条件
    ,classifytype2 varchar2(100) -- 风险暴露分类
    ,bizextendedterm number(22) -- 额度下业务延展期限月)
    ,outclassifydate varchar2(10) -- 外部评级日期
    ,termtype varchar2(36) -- 期限申请类型额度)
    ,availablenominalsum number(24,6) -- 可用名义金额
    ,afterloanorgid varchar2(32) -- 贷后管理机构
    ,outclassifyorg varchar2(200) -- 外部评级机构
    ,investway varchar2(2) -- 投资方式
    ,bizlowestfloatrate number(24,8) -- 额度下业务利率最低浮动
    ,guarantybailsubaccount varchar2(5) -- 押品转保证金子户号
    ,isrz varchar2(2) -- 是否融资合同
    ,isgovernfinance varchar2(2) -- 是否涉及政府类融资
    ,isgreenfinance varchar2(2) -- 是否为绿色信贷融资
    ,maxnominalamount number(24,6) -- 单一最高授信额度名义金额
    ,usewithoutcondition varchar2(2) -- 能否直接使用额度)
    ,businesstype2 varchar2(32) -- 专业贷款分类
    ,fundsource varchar2(18) -- 资金来源
    ,playtype varchar2(2) -- 参与方式
    ,bizmostmortgagerate number(15,8) -- 额度下业务最高抵质押率
    ,bizbailinitialrate number(24,8) -- 额度下业务初始保证金比例
    ,availableexposuresum number(24,6) -- 可用敞口金额
    ,syndicatetotalsum number(24,6) -- 银团贷款总金额
    ,isbeltroadfinance varchar2(2) -- 是否为一带一路建设投融资
    ,migtflag varchar2(80) -- 
    ,istrans varchar2(1) -- 是否转授信
    ,linecontrolmode varchar2(36) -- 集团额度管控模式超额分配/全额分配)
    ,otherlimitflag varchar2(1) -- 是否占用他用额度
    ,singlebizmostamount number(24,6) -- 额度下业务单笔最大金额
    ,exposuresum number(24,6) -- 额度敞口金额
    ,putoutorgid varchar2(32) -- 放贷机构
    ,riskexposuresum number(24,6) -- 其中，一般风险敞口金额(元)
    ,isquerycreditreport varchar2(10) -- 是否自动查询贷后报告
    ,onlineamount number(24,6) -- 线上额度(元)
    ,isconsumerfinance varchar2(2) -- 是否为消费服务类融资
    ,maxexposureamount number(24,6) -- 单一最高授信额度敞口金额
    ,ispubliccredit varchar2(2) -- 是否公开授信额度)
    ,creditauthno varchar2(200) -- 征信授权影像流水号
    ,islikeloan varchar2(2) -- 是否类信贷
    ,lowriskexposuresum number(24,6) -- 其中，类低风险敞口金额(元)
    ,drtimes number(22) -- 债务重组次数
    ,guarantybailaccount varchar2(32) -- 押品转保证金账号
    ,nominalsum number(24,6) -- 额度名义金额
    ,latestusedate date -- 额度最迟使用日期
    ,outclassifylevel varchar2(18) -- 外部债项评级
    ,isestatefinance varchar2(2) -- 是否涉及房地产融资
    ,noeffectreason varchar2(4) -- 失效原因
    ,changetype varchar2(4) -- 变更原因
    ,hxtyoperateorg varchar2(2) -- 归口管理部门
    ,classifyresulteleven varchar2(18) -- 债项分类
    ,iscreditincrement varchar2(4) -- 是否有增信
    ,hxtymainratelevel varchar2(4) -- 外部主体评级
    ,mainlevelorg varchar2(400) -- 主体评级机构
    ,mainleveldate varchar2(20) -- 主体评级日期
    ,purpose varchar2(1000) -- 资金用途
    ,investtarget varchar2(500) -- 投资标的
    ,publicorg varchar2(2) -- 发行场所
    ,approvepubsum number(24,6) -- 批准发行总额
    ,publishsum number(24,6) -- 本次发行金额
    ,issuername varchar2(120) -- 发行人名称
    ,issuerid varchar2(16) -- 发行人编号
    ,originalname varchar2(200) -- 原始权益人名称
    ,originalid varchar2(16) -- 原始权益人编号
    ,channelname varchar2(32) -- 通道方名称
    ,channelid varchar2(32) -- 通道方编号
    ,managename varchar2(200) -- 管理人名称
    ,manageid varchar2(16) -- 管理人客户号
    ,ispenetrate varchar2(2) -- 是否可穿透
    ,moneyindustryt varchar2(32) -- 资金投向行业
    ,supplychain varchar2(1) -- 供应链业务单占核心企业额度
    ,islikelowrisk varchar2(2) -- 是否类低风险
    ,focuslendtype varchar2(2) -- 集中放款业务类型
    ,isinnovate varchar2(2) -- 是否创新业务
    ,issupplychainfinance varchar2(2) -- 是否供应链金融业务
    ,lmttyp varchar2(30) -- 同业额度合同-额度类型
    ,sqdkze number(18,2) -- 
    ,isjoinlimits varchar2(2) -- 
    ,otherlimitamount number(24,6) -- 
    ,iscollectionagency varchar2(2) -- 
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
grant select on ${iol_schema}.icms_bc_cl_info to ${iml_schema};
grant select on ${iol_schema}.icms_bc_cl_info to ${icl_schema};
grant select on ${iol_schema}.icms_bc_cl_info to ${idl_schema};
grant select on ${iol_schema}.icms_bc_cl_info to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_bc_cl_info is '业务合同额度属性表';
comment on column ${iol_schema}.icms_bc_cl_info.serialno is '流水号';
comment on column ${iol_schema}.icms_bc_cl_info.lineclass is '额度种类综合/专项/其他)';
comment on column ${iol_schema}.icms_bc_cl_info.currencyrange is '项下业务币种范围';
comment on column ${iol_schema}.icms_bc_cl_info.lngotimes is '借新还旧次数';
comment on column ${iol_schema}.icms_bc_cl_info.occupynominalsum is '已用名义金额自动计算)';
comment on column ${iol_schema}.icms_bc_cl_info.afterloanuserid is '贷后管理人员';
comment on column ${iol_schema}.icms_bc_cl_info.creditflowtype is '授信业务流程类型';
comment on column ${iol_schema}.icms_bc_cl_info.creditarea is '授信区域';
comment on column ${iol_schema}.icms_bc_cl_info.approvalsuggestion is '建议审批等级';
comment on column ${iol_schema}.icms_bc_cl_info.useterm is '额度项下业务最迟到期日期';
comment on column ${iol_schema}.icms_bc_cl_info.freezeflag is '冻结标志';
comment on column ${iol_schema}.icms_bc_cl_info.bizlongestterm is '额度下业务最长期限月)';
comment on column ${iol_schema}.icms_bc_cl_info.occupyexposuresum is '已用敞口金额自动计算)';
comment on column ${iol_schema}.icms_bc_cl_info.limitusecondition is '额度使用条件';
comment on column ${iol_schema}.icms_bc_cl_info.classifytype2 is '风险暴露分类';
comment on column ${iol_schema}.icms_bc_cl_info.bizextendedterm is '额度下业务延展期限月)';
comment on column ${iol_schema}.icms_bc_cl_info.outclassifydate is '外部评级日期';
comment on column ${iol_schema}.icms_bc_cl_info.termtype is '期限申请类型额度)';
comment on column ${iol_schema}.icms_bc_cl_info.availablenominalsum is '可用名义金额';
comment on column ${iol_schema}.icms_bc_cl_info.afterloanorgid is '贷后管理机构';
comment on column ${iol_schema}.icms_bc_cl_info.outclassifyorg is '外部评级机构';
comment on column ${iol_schema}.icms_bc_cl_info.investway is '投资方式';
comment on column ${iol_schema}.icms_bc_cl_info.bizlowestfloatrate is '额度下业务利率最低浮动';
comment on column ${iol_schema}.icms_bc_cl_info.guarantybailsubaccount is '押品转保证金子户号';
comment on column ${iol_schema}.icms_bc_cl_info.isrz is '是否融资合同';
comment on column ${iol_schema}.icms_bc_cl_info.isgovernfinance is '是否涉及政府类融资';
comment on column ${iol_schema}.icms_bc_cl_info.isgreenfinance is '是否为绿色信贷融资';
comment on column ${iol_schema}.icms_bc_cl_info.maxnominalamount is '单一最高授信额度名义金额';
comment on column ${iol_schema}.icms_bc_cl_info.usewithoutcondition is '能否直接使用额度)';
comment on column ${iol_schema}.icms_bc_cl_info.businesstype2 is '专业贷款分类';
comment on column ${iol_schema}.icms_bc_cl_info.fundsource is '资金来源';
comment on column ${iol_schema}.icms_bc_cl_info.playtype is '参与方式';
comment on column ${iol_schema}.icms_bc_cl_info.bizmostmortgagerate is '额度下业务最高抵质押率';
comment on column ${iol_schema}.icms_bc_cl_info.bizbailinitialrate is '额度下业务初始保证金比例';
comment on column ${iol_schema}.icms_bc_cl_info.availableexposuresum is '可用敞口金额';
comment on column ${iol_schema}.icms_bc_cl_info.syndicatetotalsum is '银团贷款总金额';
comment on column ${iol_schema}.icms_bc_cl_info.isbeltroadfinance is '是否为一带一路建设投融资';
comment on column ${iol_schema}.icms_bc_cl_info.migtflag is '';
comment on column ${iol_schema}.icms_bc_cl_info.istrans is '是否转授信';
comment on column ${iol_schema}.icms_bc_cl_info.linecontrolmode is '集团额度管控模式超额分配/全额分配)';
comment on column ${iol_schema}.icms_bc_cl_info.otherlimitflag is '是否占用他用额度';
comment on column ${iol_schema}.icms_bc_cl_info.singlebizmostamount is '额度下业务单笔最大金额';
comment on column ${iol_schema}.icms_bc_cl_info.exposuresum is '额度敞口金额';
comment on column ${iol_schema}.icms_bc_cl_info.putoutorgid is '放贷机构';
comment on column ${iol_schema}.icms_bc_cl_info.riskexposuresum is '其中，一般风险敞口金额(元)';
comment on column ${iol_schema}.icms_bc_cl_info.isquerycreditreport is '是否自动查询贷后报告';
comment on column ${iol_schema}.icms_bc_cl_info.onlineamount is '线上额度(元)';
comment on column ${iol_schema}.icms_bc_cl_info.isconsumerfinance is '是否为消费服务类融资';
comment on column ${iol_schema}.icms_bc_cl_info.maxexposureamount is '单一最高授信额度敞口金额';
comment on column ${iol_schema}.icms_bc_cl_info.ispubliccredit is '是否公开授信额度)';
comment on column ${iol_schema}.icms_bc_cl_info.creditauthno is '征信授权影像流水号';
comment on column ${iol_schema}.icms_bc_cl_info.islikeloan is '是否类信贷';
comment on column ${iol_schema}.icms_bc_cl_info.lowriskexposuresum is '其中，类低风险敞口金额(元)';
comment on column ${iol_schema}.icms_bc_cl_info.drtimes is '债务重组次数';
comment on column ${iol_schema}.icms_bc_cl_info.guarantybailaccount is '押品转保证金账号';
comment on column ${iol_schema}.icms_bc_cl_info.nominalsum is '额度名义金额';
comment on column ${iol_schema}.icms_bc_cl_info.latestusedate is '额度最迟使用日期';
comment on column ${iol_schema}.icms_bc_cl_info.outclassifylevel is '外部债项评级';
comment on column ${iol_schema}.icms_bc_cl_info.isestatefinance is '是否涉及房地产融资';
comment on column ${iol_schema}.icms_bc_cl_info.noeffectreason is '失效原因';
comment on column ${iol_schema}.icms_bc_cl_info.changetype is '变更原因';
comment on column ${iol_schema}.icms_bc_cl_info.hxtyoperateorg is '归口管理部门';
comment on column ${iol_schema}.icms_bc_cl_info.classifyresulteleven is '债项分类';
comment on column ${iol_schema}.icms_bc_cl_info.iscreditincrement is '是否有增信';
comment on column ${iol_schema}.icms_bc_cl_info.hxtymainratelevel is '外部主体评级';
comment on column ${iol_schema}.icms_bc_cl_info.mainlevelorg is '主体评级机构';
comment on column ${iol_schema}.icms_bc_cl_info.mainleveldate is '主体评级日期';
comment on column ${iol_schema}.icms_bc_cl_info.purpose is '资金用途';
comment on column ${iol_schema}.icms_bc_cl_info.investtarget is '投资标的';
comment on column ${iol_schema}.icms_bc_cl_info.publicorg is '发行场所';
comment on column ${iol_schema}.icms_bc_cl_info.approvepubsum is '批准发行总额';
comment on column ${iol_schema}.icms_bc_cl_info.publishsum is '本次发行金额';
comment on column ${iol_schema}.icms_bc_cl_info.issuername is '发行人名称';
comment on column ${iol_schema}.icms_bc_cl_info.issuerid is '发行人编号';
comment on column ${iol_schema}.icms_bc_cl_info.originalname is '原始权益人名称';
comment on column ${iol_schema}.icms_bc_cl_info.originalid is '原始权益人编号';
comment on column ${iol_schema}.icms_bc_cl_info.channelname is '通道方名称';
comment on column ${iol_schema}.icms_bc_cl_info.channelid is '通道方编号';
comment on column ${iol_schema}.icms_bc_cl_info.managename is '管理人名称';
comment on column ${iol_schema}.icms_bc_cl_info.manageid is '管理人客户号';
comment on column ${iol_schema}.icms_bc_cl_info.ispenetrate is '是否可穿透';
comment on column ${iol_schema}.icms_bc_cl_info.moneyindustryt is '资金投向行业';
comment on column ${iol_schema}.icms_bc_cl_info.supplychain is '供应链业务单占核心企业额度';
comment on column ${iol_schema}.icms_bc_cl_info.islikelowrisk is '是否类低风险';
comment on column ${iol_schema}.icms_bc_cl_info.focuslendtype is '集中放款业务类型';
comment on column ${iol_schema}.icms_bc_cl_info.isinnovate is '是否创新业务';
comment on column ${iol_schema}.icms_bc_cl_info.issupplychainfinance is '是否供应链金融业务';
comment on column ${iol_schema}.icms_bc_cl_info.lmttyp is '同业额度合同-额度类型';
comment on column ${iol_schema}.icms_bc_cl_info.sqdkze is '';
comment on column ${iol_schema}.icms_bc_cl_info.isjoinlimits is '';
comment on column ${iol_schema}.icms_bc_cl_info.otherlimitamount is '';
comment on column ${iol_schema}.icms_bc_cl_info.iscollectionagency is '';
comment on column ${iol_schema}.icms_bc_cl_info.islimit is '';
comment on column ${iol_schema}.icms_bc_cl_info.start_dt is '开始时间';
comment on column ${iol_schema}.icms_bc_cl_info.end_dt is '结束时间';
comment on column ${iol_schema}.icms_bc_cl_info.id_mark is '增删标志';
comment on column ${iol_schema}.icms_bc_cl_info.etl_timestamp is 'ETL处理时间戳';
