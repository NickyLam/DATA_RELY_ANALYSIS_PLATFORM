/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_ap_case_pro
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_ap_case_pro
whenever sqlerror continue none;
drop table ${iol_schema}.icms_ap_case_pro purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_ap_case_pro(
    caseno varchar2(64) -- 案件项目编号
    ,bankruptendflag varchar2(12) -- 是否破产终结
    ,bankruptflag varchar2(12) -- 是否申请破产
    ,executeflag varchar2(12) -- 是否执结
    ,bankrupttype varchar2(36) -- 破产类型
    ,customerid varchar2(64) -- 当事人编号
    ,objectinterestsum number(24,6) -- 标的利息金额
    ,executedate date -- 执结日期
    ,employmentsche2 varchar2(4000) -- 二审聘请方案描述
    ,belongorgid varchar2(64) -- 所属机构
    ,objectcapitalsum number(24,6) -- 标的本金金额
    ,objectsum number(24,6) -- 标的金额
    ,suitrequest varchar2(1000) -- 诉讼请求
    ,executestage varchar2(12) -- 执行阶段
    ,updatedate date -- 更新日期
    ,realcompsum number(24,6) -- 实际赔偿金额
    ,endflag varchar2(12) -- 是否终结
    ,stopcasedate date -- 人工终止日期
    ,caseprogramstage varchar2(36) -- 案件程序阶段
    ,thirdparty varchar2(2000) -- 第三人
    ,suitprohistory varchar2(1000) -- 案件诉讼程序阶段历史
    ,fmuserid varchar2(64) -- 主办客户经理ID
    ,liquidatecaseflag varchar2(12) -- 是否清收案件
    ,propertysaveflag2 varchar2(2) -- 二审是否有财产保全
    ,agencypattern varchar2(12) -- 代理方式
    ,caseid varchar2(400) -- 案号
    ,hirelawyerflag varchar2(12) -- 是否聘请律师
    ,otherpropertydes varchar2(4000) -- 其他有效财产线索情况说明
    ,objectinterestbalance number(24,6) -- 标的利息余额
    ,winflag varchar2(12) -- 是否胜诉
    ,tmsp varchar2(64) -- 时间戳
    ,bysuitrequest varchar2(1000) -- 被诉诉请
    ,monitorflag varchar2(12) -- 是否总行监控案件
    ,defendant varchar2(2000) -- 被告
    ,employmentsche varchar2(1000) -- 聘请方案描述
    ,lawagent varchar2(160) -- 诉讼代理人
    ,zxinterest number(24,6) -- 账销案存资产欠息余额
    ,suitrequest2 varchar2(4000) -- 二审诉讼请求
    ,otherpropertydes2 varchar2(4000) -- 二审其他有效财产线索情况说明
    ,casedesc varchar2(1000) -- 案件描述
    ,closeddate date -- 审结日期
    ,lawyername varchar2(160) -- 代理律师
    ,casename varchar2(160) -- 案件名称
    ,casereason varchar2(12) -- 案由
    ,otherpartyname varchar2(2000) -- 其他当事人
    ,propertysaveflag varchar2(2) -- 是否有财产保全
    ,employmentsche1 varchar2(4000) -- 一审聘请方案描述
    ,stopcours varchar2(1000) -- 人工终止原因
    ,deleteflag varchar2(2) -- 删除标记
    ,relativecaseid varchar2(400) -- 关联案件案号
    ,customername varchar2(100) -- 当事人名称
    ,objectcurrenty varchar2(3) -- 标的币种
    ,closedflag varchar2(12) -- 是否审结
    ,stoppeddate date -- 中止日期
    ,caseprogramtype varchar2(12) -- 案件程序类型
    ,specialflag varchar2(12) -- 是否总行专案
    ,occurdate date -- 发生日期
    ,objectcapitalbalance number(24,6) -- 标的本金余额
    ,stoppedflag varchar2(12) -- 是否中止
    ,executeddate date -- 执结日期
    ,otherpropertydes1 varchar2(4000) -- 一审其他有效财产线索情况说明
    ,fileno varchar2(64) -- 影像平台编号
    ,reportflag varchar2(12) -- 是否上报总行管理
    ,enddate date -- 终结日期
    ,caseprojectdesc varchar2(1000) -- 案件方案描述
    ,objectcost number(24,6) -- 标的费用金额
    ,thirdpartyids varchar2(1000) -- 第三人编号
    ,relativecaseno varchar2(400) -- 关联案件流水号
    ,fmusername varchar2(64) -- 主办客户经理
    ,smusername varchar2(1000) -- 协办客户经理
    ,caseflag varchar2(12) -- 案件属性
    ,executedflag varchar2(12) -- 是否执结
    ,saveflag varchar2(36) -- 保存状态
    ,bankruptenddate date -- 破产终结日期
    ,bankruptstage varchar2(36) -- 破产案件阶段
    ,updateorgid varchar2(64) -- 更新机构编号
    ,accuser varchar2(2000) -- 原告
    ,updateuserid varchar2(64) -- 更新人编号
    ,acceptunitname varchar2(400) -- 受理单位名称
    ,trendinfo varchar2(1000) -- 案件动态内容
    ,approvestatus varchar2(12) -- 审批状态
    ,accuserids varchar2(1000) -- 原告编号
    ,acceptunitid varchar2(64) -- 受理单位ID
    ,seizureslist varchar2(1000) -- 查封物情况
    ,suitrequest1 varchar2(4000) -- 一审诉讼请求
    ,casetype varchar2(12) -- 案件类型
    ,relativecasename varchar2(400) -- 关联案件名称
    ,lawfirmname varchar2(160) -- 代理律所
    ,inputuserid varchar2(64) -- 登记人编号
    ,objectbalance number(24,6) -- 标的余额
    ,suitprogramstage varchar2(12) -- 诉讼程序阶段
    ,assetno varchar2(64) -- 资产编号
    ,remark varchar2(1000) -- 备注
    ,executestatus varchar2(6) -- 落实状态
    ,projectno varchar2(400) -- 项目编号
    ,replyopinion varchar2(1000) -- 答辩意见
    ,smuserid varchar2(400) -- 协办客户经理ID
    ,propertysaveflag1 varchar2(2) -- 一审是否有财产保全
    ,defendantids varchar2(1000) -- 被告人编号
    ,inputorgid varchar2(64) -- 登记机构编号
    ,inputdate date -- 登记日期
    ,bankposition varchar2(12) -- 我行地位
    ,assetpreservesche varchar2(1000) -- 资产保全方案
    ,zxbalance number(24,6) -- 账销案存资产本金余额
    ,bysuitobject varchar2(400) -- 被诉标的
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
grant select on ${iol_schema}.icms_ap_case_pro to ${iml_schema};
grant select on ${iol_schema}.icms_ap_case_pro to ${icl_schema};
grant select on ${iol_schema}.icms_ap_case_pro to ${idl_schema};
grant select on ${iol_schema}.icms_ap_case_pro to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_ap_case_pro is '案件项目表';
comment on column ${iol_schema}.icms_ap_case_pro.caseno is '案件项目编号';
comment on column ${iol_schema}.icms_ap_case_pro.bankruptendflag is '是否破产终结';
comment on column ${iol_schema}.icms_ap_case_pro.bankruptflag is '是否申请破产';
comment on column ${iol_schema}.icms_ap_case_pro.executeflag is '是否执结';
comment on column ${iol_schema}.icms_ap_case_pro.bankrupttype is '破产类型';
comment on column ${iol_schema}.icms_ap_case_pro.customerid is '当事人编号';
comment on column ${iol_schema}.icms_ap_case_pro.objectinterestsum is '标的利息金额';
comment on column ${iol_schema}.icms_ap_case_pro.executedate is '执结日期';
comment on column ${iol_schema}.icms_ap_case_pro.employmentsche2 is '二审聘请方案描述';
comment on column ${iol_schema}.icms_ap_case_pro.belongorgid is '所属机构';
comment on column ${iol_schema}.icms_ap_case_pro.objectcapitalsum is '标的本金金额';
comment on column ${iol_schema}.icms_ap_case_pro.objectsum is '标的金额';
comment on column ${iol_schema}.icms_ap_case_pro.suitrequest is '诉讼请求';
comment on column ${iol_schema}.icms_ap_case_pro.executestage is '执行阶段';
comment on column ${iol_schema}.icms_ap_case_pro.updatedate is '更新日期';
comment on column ${iol_schema}.icms_ap_case_pro.realcompsum is '实际赔偿金额';
comment on column ${iol_schema}.icms_ap_case_pro.endflag is '是否终结';
comment on column ${iol_schema}.icms_ap_case_pro.stopcasedate is '人工终止日期';
comment on column ${iol_schema}.icms_ap_case_pro.caseprogramstage is '案件程序阶段';
comment on column ${iol_schema}.icms_ap_case_pro.thirdparty is '第三人';
comment on column ${iol_schema}.icms_ap_case_pro.suitprohistory is '案件诉讼程序阶段历史';
comment on column ${iol_schema}.icms_ap_case_pro.fmuserid is '主办客户经理ID';
comment on column ${iol_schema}.icms_ap_case_pro.liquidatecaseflag is '是否清收案件';
comment on column ${iol_schema}.icms_ap_case_pro.propertysaveflag2 is '二审是否有财产保全';
comment on column ${iol_schema}.icms_ap_case_pro.agencypattern is '代理方式';
comment on column ${iol_schema}.icms_ap_case_pro.caseid is '案号';
comment on column ${iol_schema}.icms_ap_case_pro.hirelawyerflag is '是否聘请律师';
comment on column ${iol_schema}.icms_ap_case_pro.otherpropertydes is '其他有效财产线索情况说明';
comment on column ${iol_schema}.icms_ap_case_pro.objectinterestbalance is '标的利息余额';
comment on column ${iol_schema}.icms_ap_case_pro.winflag is '是否胜诉';
comment on column ${iol_schema}.icms_ap_case_pro.tmsp is '时间戳';
comment on column ${iol_schema}.icms_ap_case_pro.bysuitrequest is '被诉诉请';
comment on column ${iol_schema}.icms_ap_case_pro.monitorflag is '是否总行监控案件';
comment on column ${iol_schema}.icms_ap_case_pro.defendant is '被告';
comment on column ${iol_schema}.icms_ap_case_pro.employmentsche is '聘请方案描述';
comment on column ${iol_schema}.icms_ap_case_pro.lawagent is '诉讼代理人';
comment on column ${iol_schema}.icms_ap_case_pro.zxinterest is '账销案存资产欠息余额';
comment on column ${iol_schema}.icms_ap_case_pro.suitrequest2 is '二审诉讼请求';
comment on column ${iol_schema}.icms_ap_case_pro.otherpropertydes2 is '二审其他有效财产线索情况说明';
comment on column ${iol_schema}.icms_ap_case_pro.casedesc is '案件描述';
comment on column ${iol_schema}.icms_ap_case_pro.closeddate is '审结日期';
comment on column ${iol_schema}.icms_ap_case_pro.lawyername is '代理律师';
comment on column ${iol_schema}.icms_ap_case_pro.casename is '案件名称';
comment on column ${iol_schema}.icms_ap_case_pro.casereason is '案由';
comment on column ${iol_schema}.icms_ap_case_pro.otherpartyname is '其他当事人';
comment on column ${iol_schema}.icms_ap_case_pro.propertysaveflag is '是否有财产保全';
comment on column ${iol_schema}.icms_ap_case_pro.employmentsche1 is '一审聘请方案描述';
comment on column ${iol_schema}.icms_ap_case_pro.stopcours is '人工终止原因';
comment on column ${iol_schema}.icms_ap_case_pro.deleteflag is '删除标记';
comment on column ${iol_schema}.icms_ap_case_pro.relativecaseid is '关联案件案号';
comment on column ${iol_schema}.icms_ap_case_pro.customername is '当事人名称';
comment on column ${iol_schema}.icms_ap_case_pro.objectcurrenty is '标的币种';
comment on column ${iol_schema}.icms_ap_case_pro.closedflag is '是否审结';
comment on column ${iol_schema}.icms_ap_case_pro.stoppeddate is '中止日期';
comment on column ${iol_schema}.icms_ap_case_pro.caseprogramtype is '案件程序类型';
comment on column ${iol_schema}.icms_ap_case_pro.specialflag is '是否总行专案';
comment on column ${iol_schema}.icms_ap_case_pro.occurdate is '发生日期';
comment on column ${iol_schema}.icms_ap_case_pro.objectcapitalbalance is '标的本金余额';
comment on column ${iol_schema}.icms_ap_case_pro.stoppedflag is '是否中止';
comment on column ${iol_schema}.icms_ap_case_pro.executeddate is '执结日期';
comment on column ${iol_schema}.icms_ap_case_pro.otherpropertydes1 is '一审其他有效财产线索情况说明';
comment on column ${iol_schema}.icms_ap_case_pro.fileno is '影像平台编号';
comment on column ${iol_schema}.icms_ap_case_pro.reportflag is '是否上报总行管理';
comment on column ${iol_schema}.icms_ap_case_pro.enddate is '终结日期';
comment on column ${iol_schema}.icms_ap_case_pro.caseprojectdesc is '案件方案描述';
comment on column ${iol_schema}.icms_ap_case_pro.objectcost is '标的费用金额';
comment on column ${iol_schema}.icms_ap_case_pro.thirdpartyids is '第三人编号';
comment on column ${iol_schema}.icms_ap_case_pro.relativecaseno is '关联案件流水号';
comment on column ${iol_schema}.icms_ap_case_pro.fmusername is '主办客户经理';
comment on column ${iol_schema}.icms_ap_case_pro.smusername is '协办客户经理';
comment on column ${iol_schema}.icms_ap_case_pro.caseflag is '案件属性';
comment on column ${iol_schema}.icms_ap_case_pro.executedflag is '是否执结';
comment on column ${iol_schema}.icms_ap_case_pro.saveflag is '保存状态';
comment on column ${iol_schema}.icms_ap_case_pro.bankruptenddate is '破产终结日期';
comment on column ${iol_schema}.icms_ap_case_pro.bankruptstage is '破产案件阶段';
comment on column ${iol_schema}.icms_ap_case_pro.updateorgid is '更新机构编号';
comment on column ${iol_schema}.icms_ap_case_pro.accuser is '原告';
comment on column ${iol_schema}.icms_ap_case_pro.updateuserid is '更新人编号';
comment on column ${iol_schema}.icms_ap_case_pro.acceptunitname is '受理单位名称';
comment on column ${iol_schema}.icms_ap_case_pro.trendinfo is '案件动态内容';
comment on column ${iol_schema}.icms_ap_case_pro.approvestatus is '审批状态';
comment on column ${iol_schema}.icms_ap_case_pro.accuserids is '原告编号';
comment on column ${iol_schema}.icms_ap_case_pro.acceptunitid is '受理单位ID';
comment on column ${iol_schema}.icms_ap_case_pro.seizureslist is '查封物情况';
comment on column ${iol_schema}.icms_ap_case_pro.suitrequest1 is '一审诉讼请求';
comment on column ${iol_schema}.icms_ap_case_pro.casetype is '案件类型';
comment on column ${iol_schema}.icms_ap_case_pro.relativecasename is '关联案件名称';
comment on column ${iol_schema}.icms_ap_case_pro.lawfirmname is '代理律所';
comment on column ${iol_schema}.icms_ap_case_pro.inputuserid is '登记人编号';
comment on column ${iol_schema}.icms_ap_case_pro.objectbalance is '标的余额';
comment on column ${iol_schema}.icms_ap_case_pro.suitprogramstage is '诉讼程序阶段';
comment on column ${iol_schema}.icms_ap_case_pro.assetno is '资产编号';
comment on column ${iol_schema}.icms_ap_case_pro.remark is '备注';
comment on column ${iol_schema}.icms_ap_case_pro.executestatus is '落实状态';
comment on column ${iol_schema}.icms_ap_case_pro.projectno is '项目编号';
comment on column ${iol_schema}.icms_ap_case_pro.replyopinion is '答辩意见';
comment on column ${iol_schema}.icms_ap_case_pro.smuserid is '协办客户经理ID';
comment on column ${iol_schema}.icms_ap_case_pro.propertysaveflag1 is '一审是否有财产保全';
comment on column ${iol_schema}.icms_ap_case_pro.defendantids is '被告人编号';
comment on column ${iol_schema}.icms_ap_case_pro.inputorgid is '登记机构编号';
comment on column ${iol_schema}.icms_ap_case_pro.inputdate is '登记日期';
comment on column ${iol_schema}.icms_ap_case_pro.bankposition is '我行地位';
comment on column ${iol_schema}.icms_ap_case_pro.assetpreservesche is '资产保全方案';
comment on column ${iol_schema}.icms_ap_case_pro.zxbalance is '账销案存资产本金余额';
comment on column ${iol_schema}.icms_ap_case_pro.bysuitobject is '被诉标的';
comment on column ${iol_schema}.icms_ap_case_pro.start_dt is '开始时间';
comment on column ${iol_schema}.icms_ap_case_pro.end_dt is '结束时间';
comment on column ${iol_schema}.icms_ap_case_pro.id_mark is '增删标志';
comment on column ${iol_schema}.icms_ap_case_pro.etl_timestamp is 'ETL处理时间戳';
