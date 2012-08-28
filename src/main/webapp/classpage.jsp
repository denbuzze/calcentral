<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib tagdir="/WEB-INF/tags" prefix="tags" %>

<tags:head/>

<body class="cc-page-classpage">
	<tags:header/>
	<tags:topnavigation/>
	<div class="cc-container-main cc-container-main-full" role="main">
		<!-- Page specific HTML -->
		<div class="cc-page-classpage-container"><!-- --></div>

		<script id="cc-page-classpage-template" type="text/x-handlebars-template" style="display:none;">
			<div class="cc-container-widget cc-page-classpage-description">
				<div class="cc-widget-title">
					<h2>Course Catalog Description</h2>
				</div>
				<div class="cc-widget-main">
					{{>description}}
				</div>
			</div>
			<div class="cc-container-widget cc-page-classpage-courseinfo">
				<div class="cc-widget-title">
					<h2>Course Info</h2>
				</div>
				<div class="cc-widget-main">
					{{>courseInfo}}
				</div>
			</div>
			<div class="cc-container-widget cc-page-classpage-instructor">
				<div class="cc-widget-title">
					<h2>Instructor</h2>
				</div>
				<div class="cc-widget-main">
					{{>instructor}}
				</div>
			</div>
		</script>
		<script id="cc-page-classpage-header-template" type="text/x-handlebars-template" style="display:none;">

		</script>

		<script id="cc-page-classpage-description-template" type="text/x-handlebars-template" style="display:none;">
			{{description}}
		</script>

		<script id="cc-page-classpage-courseinfo-template" type="text/x-handlebars-template" style="display:none;">
			{{#with courseinfo}}
			<ul class="cc-page-classpage-list">
				<li><span>Format:</span><span>{{available format}}</span></li>
				<li><span>Units:</span><span>{{available units}}</span></li>
				<li><span>Semesters offered:</span><span>{{available semesters_offered}}</span></li>
				<li><span>Requirements:</span><span>{{available requirements}}</span></li>
				<li><span>Grading:</span><span>{{available grading}}</span></li>
				<li><span>Prerequisites:</span><span>{{available prereqs}}</span></li>
			</ul>
			{{/with}}
		</script>

		<script id="cc-page-classpage-instructor-template" type="text/x-handlebars-template" style="display:none;">
			<ul class="cc-page-classpage-instructor-item">
				{{#each instructors}}
					<li>
						{{#if img}}
							<img class="cc-page-classpage-instructor-profile" src="{{img}}" />
						{{/if}}
						<div class="cc-page-classpage-instructor-heading">
						{{#if name}}
							<a href="https://calnet.berkeley.edu/directory/details.pl?uid={{id}}">{{name}}</a>
						{{else}}
							<em>Instructor name is not available</em>
						{{/if}}
						{{#if title}}
							<div>{{title}}</div>
						{{/if}}
						</div>
						<ul class="cc-page-classpage-list">
							{{#if url}}<li><span>Website:</span><span><a href="{{url}}">{{url}}</a></span></li>{{/if}}
							{{#if phone}}<li><span>Phone #:</span><span>{{phone}}</span></li>{{/if}}
							{{#if office}}<li><span>Office:</span><span>{{office}}</span></li>{{/if}}
						</ul>
					</li>
				{{/each}}
			</ul>
		</script>

		<!-- END Page specific HTML -->
		<br class="clearfix" />
	</div>
	<tags:footer/>
</body>
</html>