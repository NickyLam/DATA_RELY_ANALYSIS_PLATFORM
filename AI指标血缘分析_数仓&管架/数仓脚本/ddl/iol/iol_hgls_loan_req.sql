/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol hgls_loan_req
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.hgls_loan_req
whenever sqlerror continue none;
drop table ${iol_schema}.hgls_loan_req purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.hgls_loan_req(
    req_id number(22,0) -- 申请ID:主键
    ,prod_id number(22,0) -- 产品ID:外键
    ,prod_code varchar2(4000) -- 产品编码
    ,code varchar2(4000) -- 唯一编码
    ,prd_type number(22,0) -- 产品类型:1.网贷,2.经营贷
    ,loan_apply_type varchar2(4000) -- 贷款类型
    ,prod_name varchar2(4000) -- 产品名称
    ,credit_on number(22,0) -- 预授信模式:0.关闭,１.开启
    ,cust_id number(22,0) -- 申请客户ID
    ,cust_name varchar2(4000) -- 客户姓名
    ,ent_name varchar2(4000) -- 企业名称
    ,credit_code varchar2(4000) -- 统一信用代码证
    ,cust_type varchar2(4000) -- 客户类型：A，按揭白名单
    ,file_code varchar2(4000) -- 白名单文件编码
    ,id_card_no varchar2(4000) -- 身份证号码
    ,manage_code varchar2(4000) -- 分享人（系统用户）code
    ,survey_user_id number(22,0) -- 调查员id（归属人）
    ,transator_id number(22,0) -- 经办人ID
    ,examiner_ids varchar2(4000) -- 审查者id
    ,auditor_ids varchar2(4000) -- 审批者id
    ,reconsider_ids varchar2(4000) -- 人工复议人员id
    ,share_user_id number(22,0) -- 分享者ID
    ,req_date timestamp -- 申请日期
    ,audit_date timestamp -- 审核日期
    ,loan_use varchar2(4000) -- 借款用途
    ,loan_use_other varchar2(4000) -- 借款用途
    ,reject_reason number(22,0) -- 审批拒绝原因
    ,reject_reason_other varchar2(4000) -- 审批拒绝原因
    ,auth_money number(38,8) -- 授信金额
    ,audit_status number(22,0) -- 审批状态:1 待审批 2 审批通过 3审批拒绝
    ,label_status varchar2(4000) -- 标签状态，0无标签 1已撤销 2担保人信息待补充 3担保人征信待审核
    ,process_info varchar2(4000) -- 流程记录信息，多个流程以逗号分隔
    ,is_cancel number(22,0) -- 贷款是否取消，0否1是
    ,req_type varchar2(4000) -- 进件类型：1，公共进件，2，自主营销，3，渠道进件
    ,is_self number(22,0) -- 是否自主营销
    ,survey_status number(22,0) -- 调查状态(1 准备调查 2 正在调查 3现场调查完成4调查完成）
    ,survey_date timestamp -- 准备调查时间
    ,loan_amount number(38,8) -- 申请金额,单位(万元),最大不超过产品定义的额度
    ,update_date timestamp -- 更新时间
    ,repayment_kind number(22,0) -- 还款方式:1.本金自定,2.等额本金,3.等额本息,4.定期还款,5.分期还款,6.一次性还款，字典编码hkfs
    ,comment varchar2(4000) -- 备注信息
    ,is_credit_submit number(22,0) -- 信贷历史是否提交0否1是
    ,ismanual_audit number(22,0) -- 是否开启人工审核，0否1是
    ,intervene_status number(22,0) -- 复议成功状态 0失败1成功
    ,reconsider_num varchar2(4000) -- 复议通过次数，0主借人1配偶 ,2个0表示主借人复议通过次数为2
    ,enterprise_code varchar2(4000) -- 企业编码
    ,approve_num number(22,0) -- 审批人数
    ,examine_num number(22,0) -- 审查人数
    ,isfixed_rate number(22,0) -- 是否固定利率，0否1是
    ,loan_rate number(38,8) -- 贷款日利率（%）无锡需求，可以为空
    ,channel number(22,0) -- 渠道
    ,category varchar2(4000) -- 类别:(1.短信 2.软文 3.图片 4.中介)
    ,final_price number(38,8) -- 实际成交价
    ,access_rule varchar2(4000) -- 贷款准入规则
    ,final_loan_money number(38,8) -- 实际放款金额
    ,branch_code varchar2(4000) -- 支行信息code
    ,home_branch varchar2(4000) -- 归属支行code
    ,is_house_audit_submit number(22,0) -- 房贷初审是否提交，0否1是
    ,isdel number(22,0) -- 删除标识:0.未删除,1.已删除
    ,remarks varchar2(4000) -- 备注
    ,risk_ele_submit varchar2(4000) -- 风险核查要素提交状态，0否1电调提交2二次补充信息提交
    ,collect_ele_submit varchar2(4000) -- 信息收集核查要素是否提交，0否1是
    ,query_number varchar2(4000) -- 调查报告查询编码-为随机数合字母组成，无特殊规律
    ,year_rate number(38,8) -- 年利率
    ,sync_result varchar2(4000) -- 信贷同步结果
    ,exclude_count number(22,0) -- 业务量均分，统计排除标记，默认不排除
    ,next_req_code varchar2(4000) -- 更换产品后的code
    ,change_product_user_id number(22,0) -- 更换产品操作人id
    ,change_product_user_name varchar2(4000) -- 更换产品操作人姓名
    ,is_renew_loan number(22,0) -- 是否为续贷：0.否 1.是
    ,biz_breed_encode varchar2(4000) -- 业务编号（智慧零售唯一标识）
    ,is_first_loan number(22,0) -- 是否是首贷户，0否1是
    ,renew_ori_req_code varchar2(4000) -- 续贷原进件CODE
    ,comprehensive_money number(38,8) -- 综合授信额度
    ,minor_survey_user_id varchar2(4000) -- 陪调员id
    ,marital_status varchar2(4000) -- 婚姻状况
    ,apply_balance number(38,8) -- 申请金额(元)
    ,telephone varchar2(4000) -- 联系方式
    ,model_version number(22,0) -- 是否走续贷模型，0不走续贷模型，1走续贷模型
    ,is_pos_cust number(22,0) -- 是否POS贷客户 true:是
    ,is_stock_cust number(22,0) -- 是否存量客户 true:是
    ,biz_cust_no varchar2(4000) -- 信贷客户编号
    ,biz_cust_create_date varchar2(4000) -- 信贷客户创建时间
    ,biz_contract_no varchar2(4000) -- 信贷合同编号
    ,is_ji_nong_dan varchar2(4000) -- 是否冀农担客户：0:否 1:是
    ,business_license_type varchar2(4000) -- 营业执照类型：1个体工商户、2企业、3无营业执照
    ,relationship_of_enterprise varchar2(4000) -- 借款人与企业关系：1法人、2法人配偶、3主要股东、4实际控制人、5共同借款人、6无关联
    ,scale_judgment varchar2(4000) -- 规模判断：1大型、2中型、3小型、4微型、5其它
    ,agri_loan_type varchar2(4000) -- 涉农贷款类型，字典：sndklx
    ,contrac_no varchar2(4000) -- 安心签项目编号
    ,applyorderno varchar2(4000) -- 唯一申请编号（信贷交互使用）
    ,referrer_id varchar2(4000) -- 推荐员id
    ,is_revolving_loan varchar2(4000) -- 是否循环贷款
    ,retail_rate_value varchar2(4000) -- 零售评级返回分数
    ,after_last_time timestamp -- 上次过贷后模型时间
    ,business_label varchar2(4000) -- 行业群码值
    ,credit_line_amount number(38,8) -- 首贷授信额度
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
grant select on ${iol_schema}.hgls_loan_req to ${iml_schema};
grant select on ${iol_schema}.hgls_loan_req to ${icl_schema};
grant select on ${iol_schema}.hgls_loan_req to ${idl_schema};
grant select on ${iol_schema}.hgls_loan_req to ${iel_schema};

-- comment
comment on table ${iol_schema}.hgls_loan_req is '进件申请表';
comment on column ${iol_schema}.hgls_loan_req.req_id is '申请ID:主键';
comment on column ${iol_schema}.hgls_loan_req.prod_id is '产品ID:外键';
comment on column ${iol_schema}.hgls_loan_req.prod_code is '产品编码';
comment on column ${iol_schema}.hgls_loan_req.code is '唯一编码';
comment on column ${iol_schema}.hgls_loan_req.prd_type is '产品类型:1.网贷,2.经营贷';
comment on column ${iol_schema}.hgls_loan_req.loan_apply_type is '贷款类型';
comment on column ${iol_schema}.hgls_loan_req.prod_name is '产品名称';
comment on column ${iol_schema}.hgls_loan_req.credit_on is '预授信模式:0.关闭,１.开启';
comment on column ${iol_schema}.hgls_loan_req.cust_id is '申请客户ID';
comment on column ${iol_schema}.hgls_loan_req.cust_name is '客户姓名';
comment on column ${iol_schema}.hgls_loan_req.ent_name is '企业名称';
comment on column ${iol_schema}.hgls_loan_req.credit_code is '统一信用代码证';
comment on column ${iol_schema}.hgls_loan_req.cust_type is '客户类型：A，按揭白名单';
comment on column ${iol_schema}.hgls_loan_req.file_code is '白名单文件编码';
comment on column ${iol_schema}.hgls_loan_req.id_card_no is '身份证号码';
comment on column ${iol_schema}.hgls_loan_req.manage_code is '分享人（系统用户）code';
comment on column ${iol_schema}.hgls_loan_req.survey_user_id is '调查员id（归属人）';
comment on column ${iol_schema}.hgls_loan_req.transator_id is '经办人ID';
comment on column ${iol_schema}.hgls_loan_req.examiner_ids is '审查者id';
comment on column ${iol_schema}.hgls_loan_req.auditor_ids is '审批者id';
comment on column ${iol_schema}.hgls_loan_req.reconsider_ids is '人工复议人员id';
comment on column ${iol_schema}.hgls_loan_req.share_user_id is '分享者ID';
comment on column ${iol_schema}.hgls_loan_req.req_date is '申请日期';
comment on column ${iol_schema}.hgls_loan_req.audit_date is '审核日期';
comment on column ${iol_schema}.hgls_loan_req.loan_use is '借款用途';
comment on column ${iol_schema}.hgls_loan_req.loan_use_other is '借款用途';
comment on column ${iol_schema}.hgls_loan_req.reject_reason is '审批拒绝原因';
comment on column ${iol_schema}.hgls_loan_req.reject_reason_other is '审批拒绝原因';
comment on column ${iol_schema}.hgls_loan_req.auth_money is '授信金额';
comment on column ${iol_schema}.hgls_loan_req.audit_status is '审批状态:1 待审批 2 审批通过 3审批拒绝';
comment on column ${iol_schema}.hgls_loan_req.label_status is '标签状态，0无标签 1已撤销 2担保人信息待补充 3担保人征信待审核';
comment on column ${iol_schema}.hgls_loan_req.process_info is '流程记录信息，多个流程以逗号分隔';
comment on column ${iol_schema}.hgls_loan_req.is_cancel is '贷款是否取消，0否1是';
comment on column ${iol_schema}.hgls_loan_req.req_type is '进件类型：1，公共进件，2，自主营销，3，渠道进件';
comment on column ${iol_schema}.hgls_loan_req.is_self is '是否自主营销';
comment on column ${iol_schema}.hgls_loan_req.survey_status is '调查状态(1 准备调查 2 正在调查 3现场调查完成4调查完成）';
comment on column ${iol_schema}.hgls_loan_req.survey_date is '准备调查时间';
comment on column ${iol_schema}.hgls_loan_req.loan_amount is '申请金额,单位(万元),最大不超过产品定义的额度';
comment on column ${iol_schema}.hgls_loan_req.update_date is '更新时间';
comment on column ${iol_schema}.hgls_loan_req.repayment_kind is '还款方式:1.本金自定,2.等额本金,3.等额本息,4.定期还款,5.分期还款,6.一次性还款，字典编码hkfs';
comment on column ${iol_schema}.hgls_loan_req.comment is '备注信息';
comment on column ${iol_schema}.hgls_loan_req.is_credit_submit is '信贷历史是否提交0否1是';
comment on column ${iol_schema}.hgls_loan_req.ismanual_audit is '是否开启人工审核，0否1是';
comment on column ${iol_schema}.hgls_loan_req.intervene_status is '复议成功状态 0失败1成功';
comment on column ${iol_schema}.hgls_loan_req.reconsider_num is '复议通过次数，0主借人1配偶 ,2个0表示主借人复议通过次数为2';
comment on column ${iol_schema}.hgls_loan_req.enterprise_code is '企业编码';
comment on column ${iol_schema}.hgls_loan_req.approve_num is '审批人数';
comment on column ${iol_schema}.hgls_loan_req.examine_num is '审查人数';
comment on column ${iol_schema}.hgls_loan_req.isfixed_rate is '是否固定利率，0否1是';
comment on column ${iol_schema}.hgls_loan_req.loan_rate is '贷款日利率（%）无锡需求，可以为空';
comment on column ${iol_schema}.hgls_loan_req.channel is '渠道';
comment on column ${iol_schema}.hgls_loan_req.category is '类别:(1.短信 2.软文 3.图片 4.中介)';
comment on column ${iol_schema}.hgls_loan_req.final_price is '实际成交价';
comment on column ${iol_schema}.hgls_loan_req.access_rule is '贷款准入规则';
comment on column ${iol_schema}.hgls_loan_req.final_loan_money is '实际放款金额';
comment on column ${iol_schema}.hgls_loan_req.branch_code is '支行信息code';
comment on column ${iol_schema}.hgls_loan_req.home_branch is '归属支行code';
comment on column ${iol_schema}.hgls_loan_req.is_house_audit_submit is '房贷初审是否提交，0否1是';
comment on column ${iol_schema}.hgls_loan_req.isdel is '删除标识:0.未删除,1.已删除';
comment on column ${iol_schema}.hgls_loan_req.remarks is '备注';
comment on column ${iol_schema}.hgls_loan_req.risk_ele_submit is '风险核查要素提交状态，0否1电调提交2二次补充信息提交';
comment on column ${iol_schema}.hgls_loan_req.collect_ele_submit is '信息收集核查要素是否提交，0否1是';
comment on column ${iol_schema}.hgls_loan_req.query_number is '调查报告查询编码-为随机数合字母组成，无特殊规律';
comment on column ${iol_schema}.hgls_loan_req.year_rate is '年利率';
comment on column ${iol_schema}.hgls_loan_req.sync_result is '信贷同步结果';
comment on column ${iol_schema}.hgls_loan_req.exclude_count is '业务量均分，统计排除标记，默认不排除';
comment on column ${iol_schema}.hgls_loan_req.next_req_code is '更换产品后的code';
comment on column ${iol_schema}.hgls_loan_req.change_product_user_id is '更换产品操作人id';
comment on column ${iol_schema}.hgls_loan_req.change_product_user_name is '更换产品操作人姓名';
comment on column ${iol_schema}.hgls_loan_req.is_renew_loan is '是否为续贷：0.否 1.是';
comment on column ${iol_schema}.hgls_loan_req.biz_breed_encode is '业务编号（智慧零售唯一标识）';
comment on column ${iol_schema}.hgls_loan_req.is_first_loan is '是否是首贷户，0否1是';
comment on column ${iol_schema}.hgls_loan_req.renew_ori_req_code is '续贷原进件CODE';
comment on column ${iol_schema}.hgls_loan_req.comprehensive_money is '综合授信额度';
comment on column ${iol_schema}.hgls_loan_req.minor_survey_user_id is '陪调员id';
comment on column ${iol_schema}.hgls_loan_req.marital_status is '婚姻状况';
comment on column ${iol_schema}.hgls_loan_req.apply_balance is '申请金额(元)';
comment on column ${iol_schema}.hgls_loan_req.telephone is '联系方式';
comment on column ${iol_schema}.hgls_loan_req.model_version is '是否走续贷模型，0不走续贷模型，1走续贷模型';
comment on column ${iol_schema}.hgls_loan_req.is_pos_cust is '是否POS贷客户 true:是';
comment on column ${iol_schema}.hgls_loan_req.is_stock_cust is '是否存量客户 true:是';
comment on column ${iol_schema}.hgls_loan_req.biz_cust_no is '信贷客户编号';
comment on column ${iol_schema}.hgls_loan_req.biz_cust_create_date is '信贷客户创建时间';
comment on column ${iol_schema}.hgls_loan_req.biz_contract_no is '信贷合同编号';
comment on column ${iol_schema}.hgls_loan_req.is_ji_nong_dan is '是否冀农担客户：0:否 1:是';
comment on column ${iol_schema}.hgls_loan_req.business_license_type is '营业执照类型：1个体工商户、2企业、3无营业执照';
comment on column ${iol_schema}.hgls_loan_req.relationship_of_enterprise is '借款人与企业关系：1法人、2法人配偶、3主要股东、4实际控制人、5共同借款人、6无关联';
comment on column ${iol_schema}.hgls_loan_req.scale_judgment is '规模判断：1大型、2中型、3小型、4微型、5其它';
comment on column ${iol_schema}.hgls_loan_req.agri_loan_type is '涉农贷款类型，字典：sndklx';
comment on column ${iol_schema}.hgls_loan_req.contrac_no is '安心签项目编号';
comment on column ${iol_schema}.hgls_loan_req.applyorderno is '唯一申请编号（信贷交互使用）';
comment on column ${iol_schema}.hgls_loan_req.referrer_id is '推荐员id';
comment on column ${iol_schema}.hgls_loan_req.is_revolving_loan is '是否循环贷款';
comment on column ${iol_schema}.hgls_loan_req.retail_rate_value is '零售评级返回分数';
comment on column ${iol_schema}.hgls_loan_req.after_last_time is '上次过贷后模型时间';
comment on column ${iol_schema}.hgls_loan_req.business_label is '行业群码值';
comment on column ${iol_schema}.hgls_loan_req.credit_line_amount is '首贷授信额度';
comment on column ${iol_schema}.hgls_loan_req.start_dt is '开始时间';
comment on column ${iol_schema}.hgls_loan_req.end_dt is '结束时间';
comment on column ${iol_schema}.hgls_loan_req.id_mark is '增删标志';
comment on column ${iol_schema}.hgls_loan_req.etl_timestamp is 'ETL处理时间戳';
