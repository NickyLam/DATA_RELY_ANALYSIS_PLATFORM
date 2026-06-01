/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol bdms_htes_draft_his_info
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.bdms_htes_draft_his_info
whenever sqlerror continue none;
drop table ${iol_schema}.bdms_htes_draft_his_info purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.bdms_htes_draft_his_info(
    id varchar2(60) -- ID
    ,msg_type varchar2(6) -- 交易类型： 01 承兑登记 02 承兑保证登记 03 贴现前保证 04 贴现前质押 05 贴现前转让背书 06 止付登记 07 解除止付登记 08 贴现等级 09 初始权属登记 10 付款确认 11 库存变更 12 保证增信 13 贴现后质押 14 贴现后保证 15 转贴现交易 16 质押式回购交易 17 买断式回购首期交易 18 买断式回购到期交易 19 再贴现质押式回购交易 20 提示付款交易 21 追偿交易 22 再贴现买断交易 23 非交易过户 24 电票转入 25 提示付款 26 背书存托信息
    ,draft_number varchar2(45) -- 票据号码
    ,req_type varchar2(6) -- 请求方类型： 1 中央银行 2 银行类机构 3 非银行类金融机构 4 非法人产品 5 虚拟资管参与者 6 非金融机构 7 存托类非法人产品 8 存托类虚拟系统参与者
    ,req_name varchar2(150) -- 请求方名称
    ,req_cert_no varchar2(27) -- 请求方社会信用代码
    ,req_account varchar2(48) -- 请求方账号
    ,req_mem_no varchar2(15) -- 请求方会员编码
    ,req_brh_no varchar2(15) -- 请求方机构编号
    ,req_bank_no varchar2(18) -- 请求方支付系统行号
    ,req_industry varchar2(8) -- 请求方行业分类：见中国票据交易系统直连接口规范【概述分册】的数据类型Industry
    ,req_corp_scale varchar2(6) -- 请求方企业规模：见中国票据交易系统直连接口规范【概述分册】的数据类型CorpScale
    ,req_dr_act varchar2(2) -- 是否三农企业： 0 否 1 是
    ,req_area varchar2(3) -- 地区
    ,req_is_grn varchar2(2) -- 是否绿色企业： 0 否 1 是
    ,req_misc varchar2(900) -- 请求方备注
    ,rcv_type varchar2(6) -- 接收方类型： 1 中央银行 2 银行类机构 3 非银行类金融机构 4 非法人产品 5 虚拟资管参与者 6 非金融机构 7 存托类非法人产品 8 存托类虚拟系统参与者
    ,rcv_name varchar2(150) -- 接收方名称
    ,rcv_cert_no varchar2(27) -- 接收方社会信用代码
    ,rcv_account varchar2(48) -- 接收方账号
    ,rcv_mem_no varchar2(15) -- 接收方会员编码
    ,rcv_brh_no varchar2(15) -- 接收方机构编号
    ,rcv_bank_no varchar2(18) -- 接收方支付系统行号
    ,rcv_misc varchar2(900) -- 接收方备注
    ,buss_occ_dt varchar2(12) -- 业务发生日期
    ,buss_occ_tm varchar2(21) -- 业务发生时间
    ,buss_fns_dt varchar2(12) -- 业务完成日期
    ,buss_fns_tm varchar2(21) -- 业务完成时间
    ,grnt_address varchar2(180) -- 保证人地址
    ,move_trs_type varchar2(6) -- 库存变更类型： VT01 行内移库 VT02 行内移库拒收退票 VT03 保证增信拒收退票 VT05 退回瑕疵票据 VT06 退回线下追偿票据 VT07 退回公示催告票据
    ,conf_pay_type varchar2(6) -- 付款确认类型： VM01 影像验证 VM02 实物验证
    ,conf_pay_add_type varchar2(6) -- 付款确认增补类型： VN01 自动新建 VN02 手动新建 VN03 应答发起补录影像 VN04 应答发起实物验证
    ,conf_pay_rst varchar2(6) -- 付款确认结果： RR02 需补录影像 RR03 需实物验证 RR05 审批拒绝
    ,conf_status varchar2(6) -- 付款确认状态
    ,stop_pay_type varchar2(6) -- 止付类型： ST01 挂失止付 ST02 公示催告 ST03 司法冻结
    ,stop_pay_rsn varchar2(675) -- 止付原因
    ,relieve_stp_type varchar2(6) -- 解除止付类型： RT01 挂失止付到期 RT02 除权判决 RT03 解除司法冻结 RT05 公示催告解除
    ,relieve_stp_rsn varchar2(450) -- 解除止付原因
    ,busi_type varchar2(8) -- 业务类型
    ,buy_back_date varchar2(12) -- 回购到期日
    ,real_back_date varchar2(12) -- 实际回购日
    ,buy_back_status varchar2(8) -- 回购状态： 1 正常回购 2 未回购 3 提前回购 4 逾期回购
    ,exchge_status varchar2(6) -- 置换状态： ES01 被他票替换 ES02 替换他票
    ,prmt_result varchar2(6) -- 提示付款应答结果： SU00 同意 SU01 拒绝
    ,prmt_refuse_rsn varchar2(6) -- 提示付款拒绝理由： CP01 背书签章未依次前后衔接 CP02 背书记载不清晰 CP03 背书人签章缺少单位印章、法定代表人或其授权的代理人签章 CP04 背书粘单未加盖骑缝章、骑缝章不连续或骑缝章不清 CP05 背书不规范、文字有歧义 CP06 其他 CP07 自动拒付
    ,prmt_stl_rst varchar2(6) -- 提示付款清算结果： R20 结算成功 R21 结算失败 R23 已撤销
    ,reserver1 varchar2(384) -- 预留域1
    ,reserver2 varchar2(384) -- 预留域2
    ,last_upd_opr varchar2(45) -- 最后操作员
    ,last_upd_time varchar2(21) -- 最后修改时间
    ,bp_no varchar2(45) -- 票据包编号
    ,cd_range varchar2(38) -- 子票包区间
    ,discount_range varchar2(38) -- 贴现票据子票区间
    ,transfer_flag varchar2(6) -- 不得转让标志： EM00 可再转让 EM01 不得转让
    ,req_dist_tp varchar2(6) -- 请求方识别类型 DT01 票据账户 DT02 银行账户
    ,rcv_dist_tp varchar2(6) -- 接收方识别类型 DT01 票据账户 DT02 银行账户
    ,prmt_refuse_other_inf varchar2(225) -- 提示付款拒付理由为其他时其他信息
    ,buy_back_other_inf varchar2(225) -- 提前和逾期赎回时应答方处理意见
    ,bill_beh_seq varchar2(8) -- 票据行为流水号
    ,left_cd_range varchar2(18) -- 左子票区间
    ,right_cd_range varchar2(18) -- 右子票区间
    ,req_buss_type varchar2(6) -- 请求方业务主体类别:ZT01-银行、金融机构，ZT02-企业平台，ZT03-企业非平台
    ,rcv_buss_type varchar2(6) -- 接收方业务主体类别:ZT01-银行、金融机构，ZT02-企业平台，ZT03-企业非平台
    ,req_account_name varchar2(675) -- 请求方账号名称
    ,rcv_account_name varchar2(675) -- 接收方账号名称
    ,create_time varchar2(21) -- 创建时间
    ,create_by varchar2(45) -- 创建人
    ,etl_dt date -- ETL处理日期
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list(etl_dt)(
    partition p_19000101 values (to_date('19000101','yyyymmdd'))
)
storage (initial 64k next 64k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${iol_schema}.bdms_htes_draft_his_info to ${iml_schema};
grant select on ${iol_schema}.bdms_htes_draft_his_info to ${icl_schema};
grant select on ${iol_schema}.bdms_htes_draft_his_info to ${idl_schema};
grant select on ${iol_schema}.bdms_htes_draft_his_info to ${iel_schema};

-- comment
comment on table ${iol_schema}.bdms_htes_draft_his_info is '票据历史信息表';
comment on column ${iol_schema}.bdms_htes_draft_his_info.id is 'ID';
comment on column ${iol_schema}.bdms_htes_draft_his_info.msg_type is '交易类型： 01 承兑登记 02 承兑保证登记 03 贴现前保证 04 贴现前质押 05 贴现前转让背书 06 止付登记 07 解除止付登记 08 贴现等级 09 初始权属登记 10 付款确认 11 库存变更 12 保证增信 13 贴现后质押 14 贴现后保证 15 转贴现交易 16 质押式回购交易 17 买断式回购首期交易 18 买断式回购到期交易 19 再贴现质押式回购交易 20 提示付款交易 21 追偿交易 22 再贴现买断交易 23 非交易过户 24 电票转入 25 提示付款 26 背书存托信息';
comment on column ${iol_schema}.bdms_htes_draft_his_info.draft_number is '票据号码';
comment on column ${iol_schema}.bdms_htes_draft_his_info.req_type is '请求方类型： 1 中央银行 2 银行类机构 3 非银行类金融机构 4 非法人产品 5 虚拟资管参与者 6 非金融机构 7 存托类非法人产品 8 存托类虚拟系统参与者';
comment on column ${iol_schema}.bdms_htes_draft_his_info.req_name is '请求方名称';
comment on column ${iol_schema}.bdms_htes_draft_his_info.req_cert_no is '请求方社会信用代码';
comment on column ${iol_schema}.bdms_htes_draft_his_info.req_account is '请求方账号';
comment on column ${iol_schema}.bdms_htes_draft_his_info.req_mem_no is '请求方会员编码';
comment on column ${iol_schema}.bdms_htes_draft_his_info.req_brh_no is '请求方机构编号';
comment on column ${iol_schema}.bdms_htes_draft_his_info.req_bank_no is '请求方支付系统行号';
comment on column ${iol_schema}.bdms_htes_draft_his_info.req_industry is '请求方行业分类：见中国票据交易系统直连接口规范【概述分册】的数据类型Industry';
comment on column ${iol_schema}.bdms_htes_draft_his_info.req_corp_scale is '请求方企业规模：见中国票据交易系统直连接口规范【概述分册】的数据类型CorpScale';
comment on column ${iol_schema}.bdms_htes_draft_his_info.req_dr_act is '是否三农企业： 0 否 1 是';
comment on column ${iol_schema}.bdms_htes_draft_his_info.req_area is '地区';
comment on column ${iol_schema}.bdms_htes_draft_his_info.req_is_grn is '是否绿色企业： 0 否 1 是';
comment on column ${iol_schema}.bdms_htes_draft_his_info.req_misc is '请求方备注';
comment on column ${iol_schema}.bdms_htes_draft_his_info.rcv_type is '接收方类型： 1 中央银行 2 银行类机构 3 非银行类金融机构 4 非法人产品 5 虚拟资管参与者 6 非金融机构 7 存托类非法人产品 8 存托类虚拟系统参与者';
comment on column ${iol_schema}.bdms_htes_draft_his_info.rcv_name is '接收方名称';
comment on column ${iol_schema}.bdms_htes_draft_his_info.rcv_cert_no is '接收方社会信用代码';
comment on column ${iol_schema}.bdms_htes_draft_his_info.rcv_account is '接收方账号';
comment on column ${iol_schema}.bdms_htes_draft_his_info.rcv_mem_no is '接收方会员编码';
comment on column ${iol_schema}.bdms_htes_draft_his_info.rcv_brh_no is '接收方机构编号';
comment on column ${iol_schema}.bdms_htes_draft_his_info.rcv_bank_no is '接收方支付系统行号';
comment on column ${iol_schema}.bdms_htes_draft_his_info.rcv_misc is '接收方备注';
comment on column ${iol_schema}.bdms_htes_draft_his_info.buss_occ_dt is '业务发生日期';
comment on column ${iol_schema}.bdms_htes_draft_his_info.buss_occ_tm is '业务发生时间';
comment on column ${iol_schema}.bdms_htes_draft_his_info.buss_fns_dt is '业务完成日期';
comment on column ${iol_schema}.bdms_htes_draft_his_info.buss_fns_tm is '业务完成时间';
comment on column ${iol_schema}.bdms_htes_draft_his_info.grnt_address is '保证人地址';
comment on column ${iol_schema}.bdms_htes_draft_his_info.move_trs_type is '库存变更类型： VT01 行内移库 VT02 行内移库拒收退票 VT03 保证增信拒收退票 VT05 退回瑕疵票据 VT06 退回线下追偿票据 VT07 退回公示催告票据';
comment on column ${iol_schema}.bdms_htes_draft_his_info.conf_pay_type is '付款确认类型： VM01 影像验证 VM02 实物验证';
comment on column ${iol_schema}.bdms_htes_draft_his_info.conf_pay_add_type is '付款确认增补类型： VN01 自动新建 VN02 手动新建 VN03 应答发起补录影像 VN04 应答发起实物验证';
comment on column ${iol_schema}.bdms_htes_draft_his_info.conf_pay_rst is '付款确认结果： RR02 需补录影像 RR03 需实物验证 RR05 审批拒绝';
comment on column ${iol_schema}.bdms_htes_draft_his_info.conf_status is '付款确认状态';
comment on column ${iol_schema}.bdms_htes_draft_his_info.stop_pay_type is '止付类型： ST01 挂失止付 ST02 公示催告 ST03 司法冻结';
comment on column ${iol_schema}.bdms_htes_draft_his_info.stop_pay_rsn is '止付原因';
comment on column ${iol_schema}.bdms_htes_draft_his_info.relieve_stp_type is '解除止付类型： RT01 挂失止付到期 RT02 除权判决 RT03 解除司法冻结 RT05 公示催告解除';
comment on column ${iol_schema}.bdms_htes_draft_his_info.relieve_stp_rsn is '解除止付原因';
comment on column ${iol_schema}.bdms_htes_draft_his_info.busi_type is '业务类型';
comment on column ${iol_schema}.bdms_htes_draft_his_info.buy_back_date is '回购到期日';
comment on column ${iol_schema}.bdms_htes_draft_his_info.real_back_date is '实际回购日';
comment on column ${iol_schema}.bdms_htes_draft_his_info.buy_back_status is '回购状态： 1 正常回购 2 未回购 3 提前回购 4 逾期回购';
comment on column ${iol_schema}.bdms_htes_draft_his_info.exchge_status is '置换状态： ES01 被他票替换 ES02 替换他票';
comment on column ${iol_schema}.bdms_htes_draft_his_info.prmt_result is '提示付款应答结果： SU00 同意 SU01 拒绝';
comment on column ${iol_schema}.bdms_htes_draft_his_info.prmt_refuse_rsn is '提示付款拒绝理由： CP01 背书签章未依次前后衔接 CP02 背书记载不清晰 CP03 背书人签章缺少单位印章、法定代表人或其授权的代理人签章 CP04 背书粘单未加盖骑缝章、骑缝章不连续或骑缝章不清 CP05 背书不规范、文字有歧义 CP06 其他 CP07 自动拒付';
comment on column ${iol_schema}.bdms_htes_draft_his_info.prmt_stl_rst is '提示付款清算结果： R20 结算成功 R21 结算失败 R23 已撤销';
comment on column ${iol_schema}.bdms_htes_draft_his_info.reserver1 is '预留域1';
comment on column ${iol_schema}.bdms_htes_draft_his_info.reserver2 is '预留域2';
comment on column ${iol_schema}.bdms_htes_draft_his_info.last_upd_opr is '最后操作员';
comment on column ${iol_schema}.bdms_htes_draft_his_info.last_upd_time is '最后修改时间';
comment on column ${iol_schema}.bdms_htes_draft_his_info.bp_no is '票据包编号';
comment on column ${iol_schema}.bdms_htes_draft_his_info.cd_range is '子票包区间';
comment on column ${iol_schema}.bdms_htes_draft_his_info.discount_range is '贴现票据子票区间';
comment on column ${iol_schema}.bdms_htes_draft_his_info.transfer_flag is '不得转让标志： EM00 可再转让 EM01 不得转让';
comment on column ${iol_schema}.bdms_htes_draft_his_info.req_dist_tp is '请求方识别类型 DT01 票据账户 DT02 银行账户';
comment on column ${iol_schema}.bdms_htes_draft_his_info.rcv_dist_tp is '接收方识别类型 DT01 票据账户 DT02 银行账户';
comment on column ${iol_schema}.bdms_htes_draft_his_info.prmt_refuse_other_inf is '提示付款拒付理由为其他时其他信息';
comment on column ${iol_schema}.bdms_htes_draft_his_info.buy_back_other_inf is '提前和逾期赎回时应答方处理意见';
comment on column ${iol_schema}.bdms_htes_draft_his_info.bill_beh_seq is '票据行为流水号';
comment on column ${iol_schema}.bdms_htes_draft_his_info.left_cd_range is '左子票区间';
comment on column ${iol_schema}.bdms_htes_draft_his_info.right_cd_range is '右子票区间';
comment on column ${iol_schema}.bdms_htes_draft_his_info.req_buss_type is '请求方业务主体类别:ZT01-银行、金融机构，ZT02-企业平台，ZT03-企业非平台';
comment on column ${iol_schema}.bdms_htes_draft_his_info.rcv_buss_type is '接收方业务主体类别:ZT01-银行、金融机构，ZT02-企业平台，ZT03-企业非平台';
comment on column ${iol_schema}.bdms_htes_draft_his_info.req_account_name is '请求方账号名称';
comment on column ${iol_schema}.bdms_htes_draft_his_info.rcv_account_name is '接收方账号名称';
comment on column ${iol_schema}.bdms_htes_draft_his_info.create_time is '创建时间';
comment on column ${iol_schema}.bdms_htes_draft_his_info.create_by is '创建人';
comment on column ${iol_schema}.bdms_htes_draft_his_info.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.bdms_htes_draft_his_info.etl_timestamp is 'ETL处理时间戳';
